# Class: profile::puppet::splunk_hec
# @summary Installs  Splunk hec and configures Puppet report processor for Splunk,
#
#
# @example
#   include profile::puppet::splunk_hec
#
# @param splunk_server
#   Specifies a Splunk server if not specified used Fact[fqdn]
#   setup to be referenced from another profile as `$profile::puppet::splunk_server_fqdn`
#
# @param splunk_hec_token
#   'bba862fd-c09c-43e1-90f7-87221f362296', # must match the value for splunk_input['hec_puppetsummary_token']
#
class profile::puppet::splunk_hec (
  Optional[String]  $splunk_server    = undef,
  String            $splunk_hec_token = 'bba862fd-c09c-43e1-90f7-87221f362296', # must match the value for splunk_input['hec_puppetsummary_token']
) {
  case $splunk_server {
    undef: {
      if defined_with_params(Class[splunk::params], {'server' => $facts['fqdn'] }) {
          $splunk_server_fqdn = $facts['fqdn']
      }
      else {
        $splunk_server_query = 'nodes[certname]{
          resources {
            type = "Class"
            and
            title = "profile::infrastructure::splunk::splunk_server"
            }
          }'
        $puppetdb_result = puppetdb_query($splunk_server_query).map |$value| { $value["certname"] }
        $splunk_server_fqdn = String.new($puppetdb_result[0])
      }
    }
    default: {
      $splunk_server_fqdn = $splunk_server
    }
  }

  if $splunk_server_fqdn != undef and $splunk_server_fqdn != '' {
    notice("Splunk server FQDN is: ${splunk_server_fqdn}")
  }

  # resources
  class {'splunk_hec':
    url            => "https://${splunk_server_fqdn}:8088/services/collector",
    token          => $splunk_hec_token,
    enable_reports => true
  }

#  ** Disabled for now as changing facts_terminus causes CD4PE Impact Analysis to break **
#  $current_pe_master_classes = node_groups('PE Master')['PE Master']['classes']
#
#  $class_attribs_to_add = {
#    'puppet_enterprise::profile::master' => { 'facts_terminus' => 'splunk_hec' }
#  }
#
#  node_group { 'PE Master':
#    classes => deep_merge($current_pe_master_classes, $class_attribs_to_add),
#    notify  => Service['pe-puppetserver']
#  }

}

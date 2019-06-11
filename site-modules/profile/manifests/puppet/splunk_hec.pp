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
    url            => $splunk_server_fqdn,
    token          => $splunk_hec_token,
    enable_reports => true
  }

}

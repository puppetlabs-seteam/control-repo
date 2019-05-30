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
class profile::puppet::splunk_hec(
  Optional[String]  $splunk_server  = undef,
  String            $splunk_hec_token   = 'bba862fd-c09c-43e1-90f7-87221f362296', # must match the value for splunk_input['hec_puppetsummary_token']
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
        $splunk_server_fqdn = puppetdb_query($splunk_server_query).map |$value| { $value["certname"] }
      }
    }
    default: {
      $splunk_server_fqdn = $splunk_server
    }
  }
if $splunk_server_fqdn {
  # resources
  class {'splunk_hec':
    server => $splunk_server_fqdn,                  # replace with your Splunk servername
    token  => $splunk_hec_token,
  }
}

  ini_setting { '[master:reports]':
    ensure            => present,
    section           => 'master',
    setting           => 'reports',
    key_val_separator => '=',
    value             => 'puppetdb,splunk_hec',
    path              => $settings::config,
    notify            => Service['pe-puppetserver']
  }
}

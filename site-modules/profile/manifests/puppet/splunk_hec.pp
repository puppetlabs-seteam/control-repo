# Class: profile::puppet::splunk_hec

# @summary Installs  Splunk hec and configures Puppet report processor for Splunk,
#
#
# @example
#   include profile::infrastructure::splunk::splunk_server
#   
# @param splunk_server
#   Specifies a Splunk server if not specified used Fact[fqdn]
#   setup to be referenced from another profile as `$profile::infrastructure::splunk::splunk_server::splunk_server_fqdn`
#
class profile::puppet::splunk_hec {
  # resources
  class {'splunk_hec':
    server => 'splunk.inf.puppet.vm',                  # replace with your Splunk servername
    token  => 'bba862fd-c09c-43e1-90f7-87221f362296'   # must match the value for splunk_input['hec_puppetsummary_token']
  }

  ini_setting { '[master:reports]':
    ensure            => present,
    section           => 'master',
    setting           => 'reports',
    key_val_separator => '=',
    value             => 'puppetdb,splunk_hec',
    path              => $facts['puppet_config'],
    notify            => Service['pe-puppetserver']
  }
}

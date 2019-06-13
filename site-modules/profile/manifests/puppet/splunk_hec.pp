# Class: profile::puppet::splunk_hec
# @summary Installs  Splunk hec and configures Puppet report processor for Splunk,
#
#
# @example
#   include profile::puppet::splunk_hec
#
# @param splunk_server
#   Specifies a Splunk server to use
#
# @param splunk_hec_token
#   'bba862fd-c09c-43e1-90f7-87221f362296', # must match the value for splunk_input['hec_puppetsummary_token']
#
class profile::puppet::splunk_hec (
  String $splunk_server,
  String $splunk_hec_token = 'bba862fd-c09c-43e1-90f7-87221f362296', # must match the value for splunk_input['hec_puppetsummary_token']
) {

  # resources
  class {'splunk_hec':
    url            => "https://${splunk_server}:8088/services/collector",
    token          => $splunk_hec_token,
    enable_reports => true,
    manage_routes  => true
  }

}

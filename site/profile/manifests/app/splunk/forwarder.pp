# Splunk Forwarder class
class profile::app::splunk::forwarder (
  Optional[String] $splunk_server = undef,
){

  # if someone doesn't specify a splunk_server as a param, query PuppetDB
  # This query grabs the host information for the Splunk server and creates an Exported Host Resource.

  if $splunk_server == undef {
    $splunk_nodes_query = 'resources[certname] { type = "Class" and title = "Splunk" }'
    $_splunk_server_results = puppetdb_query($splunk_nodes_query)
    if size($_splunk_server_results) == 0 {
      fail('No splunk server provided as a param or found in query')
    }
    $_splunk_server = $splunk_server_results[0][certname]
    Host  <<| tag == 'splunkserver' |>>
  } else {
    $_splunk_server = $splunk_server
  }

  class { '::splunk::params':
    server   => $_splunk_server,
    src_root => $splunk::params::src_root,
  }
  # Splunkforwarder input setup.  This is just collecting the /var/log/messages
  # from each node and shipping its logs to the splunk server
  @splunkforwarder_input { "${hostname}_messages" :
    section => 'monitor:///var/log/messages',
    setting => 'sourcetype',
    value   => "${hostname}_messages",
    tag     => 'splunk_forwarder'
  }

  # This is section forwards the system Audit log
  @splunkforwarder_input { "${hostname}_audit" :
    section => 'monitor:///var/log/audit/audit.log',
    setting => 'sourcetype',
    value   => "${hostname}_audit",
    tag     => 'splunk_forwarder'
  }
}

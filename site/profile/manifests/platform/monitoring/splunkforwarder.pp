# Splunk Forwarder class
class profile::platform::monitoring::splunkforwarder (
  $splunk_server,
){
if $splunk_server == undef {
  $splunk_nodes_query = 'resources[certname] { type = "Class" and title = "Splunk" }'
  $splunk_server = puppetdb_query($splunk_nodes_query)[0][certname]
  notify {"$splunk_nodes":}
}
  class { '::splunk::params':
    server   => $splunk_server,
    src_root => 'http://tseteam.s3.amazonaws.com/files',
}
include ::splunk::forwarder
}
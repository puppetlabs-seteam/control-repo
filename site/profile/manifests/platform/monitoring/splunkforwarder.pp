class profile::platform::monitoring::splunkforwarder (
  #$splunk_server          = 'ip-10-98-10-78.us-west-2.compute.internal',
  $splunk_nodes_query = 'resources[certname] { type = "Class" and title = "Splunk" }'
  $splunk_nodes = puppetdb_query($splunk_nodes_query)[0][certname]

){

  class { '::splunk::params':
    server   => $splunk_server,
    src_root => 'http://tseteam.s3.amazonaws.com/files',
}

include ::splunk::forwarder


notify {"$splunk_nodes":}

}

class profile::platform::monitoring::splunkforwarder (
  $splunk_server          = 'ip-10-98-10-78.us-west-2.compute.internal',
){

  class { '::splunk::params':
    server           => $splunk_server,
    src_root         => "http://tseteam.s3.amazonaws.com/files",
}

include ::splunk::forwarder


  $splunk_srv     = Splunk_server <<||>>

notify{"The value is: ${splunk_srv}": }
#notify { 'Splunk_server <<||>>': }
 
  
}

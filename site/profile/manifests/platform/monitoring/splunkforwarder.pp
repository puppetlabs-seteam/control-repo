class profile::platform::monitoring::splunkforwarder (
  $splunk_server          = 'ip-10-98-10-78.us-west-2.compute.internal',

){

  class { '::splunk::params':
    server => $splunk_server,
}

include ::splunk::forwarder


}

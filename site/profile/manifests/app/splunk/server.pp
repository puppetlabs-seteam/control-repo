# splunk server module
class profile::app::splunk::server (
  $purge_inputs       = false,
  $purge_outputs      = false,
  $version            = '6.6.1',
  $build              = 'aeae3fe0c5af',
  $server             = 'monitor.inf.puppet.vm',
) {

  $src_root = 'http://tseteam.s3.amazonaws.com/files'

  #potential for other environments, collecting the files from the puppet file server
  #$src_root = "puppet:///"

  class { 'splunk::params':
    version      => $version,
    build        => $build,
    server       => $server,
    src_root     => $src_root,
    logging_port => $logging_port,
    splunkd_port => $splunkd_port,
  }

include splunk

}

# splunk server module
class profile::app::splunk::server (
  $purge_inputs       = false,
  $purge_outputs      = false,
  $version            = '6.6.1',
  $build              = 'aeae3fe0c5af',
  #$file_host          = 'master.inf.puppet.vm',
  #$file_path          = '/opt/tse-files/splunk/files/splunk/linux',
  $server             = 'monitor.inf.puppet.vm',
) {

  #potential for demo environment with the file server running on port 81
  $src_root = "http://tseteam.s3.amazonaws.com/files"
  
  #potential for other environments, collecting the files from the puppet file server
  #$src_root = "puppet:///"

  class { 'splunk::params':
    version  => $version,
    build    => $build,
    server   => $server,
    src_root => $src_root,
    logging_port  => $logging_port,
    splunkd_port  => $splunkd_port,
  }

include splunk

  # Declare:
  #  @@splunk_server { $::hostname:
  #  }

  @@file {"exported_${::hostname}":
    path         => "/tmp/${::hostname}",
    content      => "${::hostname}",
    mode         => 0640,
    tag          => 'splunk_server_hostname',
}

}

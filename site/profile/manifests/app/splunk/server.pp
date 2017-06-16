# splunk server module
class profile::app::splunk::server (
  $purge_inputs       = false,
  $purge_outputs      = false,
  $version            = '6.6.1',
  $build              = 'aeae3fe0c5af',
  $file_host          = 'master.inf.puppet.vm',
  $file_path          = '/opt/tse-files/splunk/files/splunk/linux',
  $server             = 'monitor.inf.puppet.vm',
) {

  $src_root = "http://$file_host:81/$file_path",

  class { 'splunk::params':
    version  => $version,
    build    => $build,
    server   => $server,
    src_root => $src_root,
    logging_port  => $logging_port,
    splunkd_port  => $splunkd_port,
    web_port      => $web_port,
    purge_inputs  => $purge_inputs,
    purge_outputs => $purge_outputs,
  }

#  class { 'splunk':
#  }
#

  }

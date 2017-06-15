class profile::app::splunk (
  $purge_inputs    = false,
  $purge_outputs   = false,
  #$src_server      = 'master.inf.puppet.vm',
  #$src_ip          = '',
  #$src_path        = 'splunk/files',
  $version         = '6.6.1',
  $build           = 'aeae3fe0c5af',
) {

  $src_root       = "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=6.6.1&product=universalforwarder&filename=splunkforwarder-6.6.1-aeae3fe0c5af-linux-2.6-x86_64.rpm&wget=true"

# Sets the source server host/ip information on the node.
#  host { $src_server:
#    ip => $src_ip,
#  }

  class { 'splunk::params':
    version              => $version,
    build                => $build,
    server               => $server,
  }

  class { 'splunk':
    logging_port  => $logging_port,
    splunkd_port  => $splunkd_port,
    web_port      => $web_port,
    purge_inputs  => $purge_inputs,
    purge_outputs => $purge_outputs,
  }

}

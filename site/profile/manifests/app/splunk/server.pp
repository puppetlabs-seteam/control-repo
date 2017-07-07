# splunk server module
class profile::app::splunk::server (
) {

  #Currently the src_root = S3 bucket, set in Hiera.  This is an option for using the master file server.
  #$src_root = "puppet:///<path to files> refer to splunk module documentation for proper folder structure"

  class { 'splunk::params':
    version      => $version,
    build        => $build,
    server       => $server,
    src_root     => splunk::params:src_root,
    logging_port => $logging_port,
    splunkd_port => $splunkd_port,
  }

  # Exported resource for the IP of the Splunk Server.
  # The idea is to export the server IP and use its value in the
  # splunkforwarder manifest for setting the host value.
  # A "poor persons" DNS fix.

    @@host { $facts['fqdn'] :
      comment      => 'Splunk Server',
      ip           => $facts['ipaddress'],
      tag          => 'splunkserver',
    }
}

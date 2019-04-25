class profile::puppet::cd4pe (
  String[1] $cd4pe_image = 'puppet/continuous-delivery-for-puppet-enterprise',
) {
  include profile::app::docker
  include cd4pe

  class { 'cd4pe::root_config':
    root_email       => 'noreply@puppet.com',
    root_password    => Sensitive('puppetlabs'),
    storage_provider => 'DISK',
  }
}


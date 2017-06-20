# @summary This profile installs apache and turns off the default vhost
class profile::app::sample_website::apache {

  class { '::apache':
    default_vhost => false,
  }

}

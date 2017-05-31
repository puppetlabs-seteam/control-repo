# @summary This profile installs apache and turns off the default vhost
class profile::generic_webdemo::apache {

  class { 'apache':
    default_vhost => false,
  }

}

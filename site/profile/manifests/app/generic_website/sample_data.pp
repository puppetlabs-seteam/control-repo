# @summary This profile installs mysql without default accounts
class profile::generic_webdemo::mysql {

  class { 'mysql::server':
    remove_default_accounts => true
  }

}

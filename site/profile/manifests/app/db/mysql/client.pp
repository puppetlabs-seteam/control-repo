class profile::app::db::mysql::client {

  case $::facts['kernel'] {
    'windows': {
      fail('Unsupported OS')
    }
    default: {
      include ::mysql::client
      class {'::mysql::bindings':
          php_enable => true,
      }
    }
  }

}

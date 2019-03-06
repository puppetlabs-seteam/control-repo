class profile::app::db::mysql::server {

  case $::facts['kernel'] {
    'windows': {
      fail('Unsupported OS')
    }
    default: {
      include ::mysql::server
      include ::mysql::client
    }
  }

}

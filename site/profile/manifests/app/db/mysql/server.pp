class profile::app::db::mysql::server(
  $override_options = undef,
) {

  case $::facts['kernel'] {
    'windows': {
      fail('Unsupported OS')
    }
    default: {
      class { ::mysql::server:
        override_options => $override_options,
      }
      include ::mysql::client
    }
  }

}

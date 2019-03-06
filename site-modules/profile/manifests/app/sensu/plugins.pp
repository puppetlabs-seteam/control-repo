#
class profile::app::sensu::plugins (
  Array $plugin_list,
)
{
  if $facts['os']['family'] != 'windows' {
    include gcc

    Package {
      ensure  => 'installed',
      provider => sensu_gem,
    }
    package { $plugin_list:
      require  => Class['gcc']
    }
  } else {
    package {['sensu-plugins-windows','sensu-plugins-http']:
      ensure   => 'installed',
      provider => sensu_gem
    }
  }
}

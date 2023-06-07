#
class profile::app::sensu::plugins (
  Array $plugin_list,
){
  case $facts['os']['family'] {
    'RedHat': {
      $packages = ['gcc', 'gcc-c++']

      package { $packages:
        ensure   => 'installed',
        provider => sensu_gem,
      }
      package { $plugin_list:
        require  => Class['gcc']
      }
    }
    'windows': {
      package { ['sensu-plugins-windows','sensu-plugins-http']:
        ensure   => 'installed',
        provider => sensu_gem
      }
    }
    default: {
      fail("Class['profile::app::sensu::plugins']: Unsupported OS Family: ${facts['os']['family']}")
    }
  }
}

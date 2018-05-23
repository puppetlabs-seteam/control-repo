# install sensu server
class profile::app::sensu {
  include profile::app::sensu::server
  include profile::app::sensu::plugins
  include profile::app::sensu::checks
  include profile::app::sensu::handlers
  class { 'profile::app::sensu::uchiwa':
    require => Class['::profile::app::sensu::server']
  }
}

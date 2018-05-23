# @summary This role installs sensu_server
class role::sensu_server {
  class {'profile::platform::baseline':
    enable_monitoring => false
  }

  include profile::app::sensu
}

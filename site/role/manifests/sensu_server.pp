# @summary This role installs sensu_server
class role::sensu_server {
  include ::profile::platform::baseline
  include ::profile::app::sensu
}

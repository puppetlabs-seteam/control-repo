# @summary This role installs jenkins_slave
class role::jenkins_slave {
  include ::profile::platform::baseline
  include ::profile::app::jenkins::slave
}

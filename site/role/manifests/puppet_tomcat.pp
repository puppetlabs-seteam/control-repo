# @summary This role installs puppet tomcat app
class role::puppet_tomcat {
  include ::profile::platform::baseline
  include ::profile::app::puppet_tomcat
}

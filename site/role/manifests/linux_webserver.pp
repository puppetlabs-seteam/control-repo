class role::linux_webserver {
  include ::profile::platform::baseline
  include ::profile::app::webserver::apache
}

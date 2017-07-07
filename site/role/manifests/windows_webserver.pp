# @summary This role installs IIS and sample content on port 80.
class role::windows_webserver {
  include ::profile::platform::baseline
  include ::profile::app::webserver::iis
}

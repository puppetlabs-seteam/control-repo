# @summary This role installs an apache webserver and sample content on port 80.
class role::sample_website {
  include ::profile::platform::baseline
  include ::profile::app::sample_website
}

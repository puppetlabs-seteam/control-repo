class profile::platform::windows {

  include profile::platform::users::windows
  include profile::platform::general::windows_regkeys
  include profile::platform::packages::windows
  include profile::platform::firewall::windows

}

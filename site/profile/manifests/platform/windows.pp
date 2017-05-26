class profile::platform::windows {

  include profile::platform::general::windows_users
  include profile::platform::general::windows_regkeys
  include profile::platform::packages::windows
  include profile::platform::firewall::windows

}

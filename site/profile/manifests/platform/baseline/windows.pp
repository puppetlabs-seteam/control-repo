class profile::platform::baseline::windows {

  include ::profile::platform::baseline::windows::common
  include ::profile::platform::baseline::windows::packages
  include ::profile::platform::baseline::windows::powershell
  include ::profile::platform::baseline::users::windows

}

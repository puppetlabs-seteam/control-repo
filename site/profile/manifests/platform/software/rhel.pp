class profile::platform::rhel {

  include profile::platform::remote::rhel
  include profile::platform::packages::rhel
  include profile::platform::general::rhel_users

}

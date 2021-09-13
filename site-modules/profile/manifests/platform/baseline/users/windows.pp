class profile::platform::baseline::users::windows {

  # CUSTOM USERS
  user { 'puppetadmin':
    ensure   => present,
    password => 'Puppetlabs@123!',
    groups   => ['Administrators'],
  }

}

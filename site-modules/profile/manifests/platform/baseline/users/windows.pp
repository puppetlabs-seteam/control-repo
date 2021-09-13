class profile::platform::baseline::users::windows {

  # CUSTOM USERS
  user { 'puppetadmin':
    ensure   => present,
    password => 'puppetlabs',
    groups   => ['Administrators'],
  }

}

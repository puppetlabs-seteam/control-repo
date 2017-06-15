class profile::platform::users::windows {

  # CUSTOM USERS
  user { 'Puppet Demo':
    ensure   => present,
    groups   => ['Administrators'],
  }

}

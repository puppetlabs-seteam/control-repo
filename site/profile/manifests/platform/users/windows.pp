class profile::platform::general::windows {

  # CUSTOM USERS
  user { 'Puppet Demo':
    ensure   => present,
    groups   => ['Administrators'],
  }

}

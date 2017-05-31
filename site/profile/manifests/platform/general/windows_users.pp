class profile::platform::general::windows_users {

  # CUSTOM USERS
  user { 'Puppet Demo':
    ensure   => present,
    groups   => ['Administrators'],
  }

}

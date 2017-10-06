class profile::platform::baseline::users::windows {

  # CUSTOM USERS
  user { 'Sample Demo':
    ensure   => present,
    password => 'Puppet4Life!',
    groups   => ['Administrators'],
  }

}

class profile::platform::baseline::users::windows {

  # CUSTOM USERS
  user { 'Puppet Demo':
    ensure => present,
    groups => ['Administrators'],
  }

}

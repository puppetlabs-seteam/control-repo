class profile::platform::baseline::users::windows {

  # CUSTOM USERS
  user { 'Puppet Demo':
    ensure   => present,
    password => '$6$wpNwL0xA$3guV4Ec62ElYIurtD8Or7j4awZO',
    groups   => ['Administrators'],
  }

}

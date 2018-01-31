class profile::platform::baseline::users::windows {

  # CUSTOM USERS
<<<<<<< HEAD
  user { 'Puppet Demo':
    ensure   => present,
    password => '$6$wpNwL0xA$3guV4Ec62ElYIurtD8Or7j4awZO',
=======
  user { 'Sample Demo':
    ensure   => present,
    password => 'Puppet4Life!17',
>>>>>>> 67c7cc46500def23dab1011343595df44d068d65
    groups   => ['Administrators'],
  }

}

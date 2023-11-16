#
class profile::platform::baseline::windows::users {
  user { 'Sample Demo':
    ensure   => present,
    password => 'Puppet4Life!17',
    groups   => ['Administrators'],
  }
}

#
class profile::platform::baseline::windows::users (
  $password,
) {
  user { 'Sample Demo':
    ensure   => present,
    password => $password,
    groups   => ['Administrators'],
  }
}

#
class profile::platform::baseline::linux::users (
  $password, # This should be a password hash for use in /etc/shadow.
) {
  user { 'PuppetSE':
    ensure   => 'present',
    comment  => 'SE Demo Account',
    gid      => '100',
    home     => '/',
    password => $password,
    shell    => '/bin/bash',
    uid      => '1010',
  }
}

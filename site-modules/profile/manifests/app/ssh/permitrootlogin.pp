class profile::app::ssh::permitrootlogin (
  Enum['present','absent'] $ensure = present,
  Enum['yes','no'] $value = 'yes',
) {

  sshd_config { 'PermitRootLogin':
    ensure => $ensure,
    value  => $value,
  }

}

class profile::app::rgbank {

  if $::osfamily != 'RedHat' {
    fail('Unsupported OS')
  }

  require ::profile::app::rgbank::db
  require ::profile::app::rgbank::webhead
  require ::profile::app::rgbank::lb

}

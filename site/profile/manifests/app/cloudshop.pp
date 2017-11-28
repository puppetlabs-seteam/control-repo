class profile::app::cloudshop {

  case $::kernel {
    'windows': {
      if $::iis_version == '8.5' {
        include profile::app::cloudshop::sqlserver::init
        include profile::app::cloudshop::webapp::db
        include profile::app::cloudshop::webapp::init
      }
    }
    default: {
      fail('Unsupported OS')
    }
  }

}

class profile::app::cloudshop {

  case $::kernel {
    'windows': {
      if $::operatingsystemrelease == '2012 R2' {
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

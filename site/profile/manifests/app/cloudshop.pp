class profile::app::cloudshop {

  case $::facts['kernel'] {
    'windows': {
      include profile::app::cloudshop::sqlserver::init
      include profile::app::cloudshop::webapp::db
      include profile::app::cloudshop::webapp::init
    }
    default: {
      fail('Unsupported OS')
    }
  }

}

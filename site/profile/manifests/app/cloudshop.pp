class profile::app::cloudshop {
  include profile::app::cloudshop::sqlserver::init
  include profile::app::cloudshop::webapp::init
}

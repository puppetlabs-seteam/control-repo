# Main class that declares SQL, IISDB, and creates an
# instance of the attachDB defined type.
class profile::app::cloudshop::sqlserver::init (
  $sqlserver_version = '2014',
  $mount_iso = true,
) {

  if $mount_iso {
    contain profile::app::cloudshop::sqlserver::mount
    Class['profile::app::cloudshop::sqlserver::mount'] -> Class['profile::app::cloudshop::sqlserver::sql']
  }

  contain profile::app::cloudshop::sqlserver::sql
}

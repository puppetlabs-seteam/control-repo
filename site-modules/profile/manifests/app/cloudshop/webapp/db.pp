class profile::app::cloudshop::webapp::db (
  $dbpass,
  $dbinstance    = 'MYINSTANCE',
  $dbuser        = 'CloudShop',
  $dbname        = 'AdventureWorks2012',
  $dbserver      = $facts['networking']['hostname'],
  $file_source   = 'https://s3-us-west-2.amazonaws.com/tseteam/files/sqlwebapp',
){
  profile::app::cloudshop::sqlserver::attachdb { $dbname:
    file_source => $file_source,
    dbinstance  => $dbinstance,
    dbpass      => $dbpass,
    owner       => $dbuser,
  }
}

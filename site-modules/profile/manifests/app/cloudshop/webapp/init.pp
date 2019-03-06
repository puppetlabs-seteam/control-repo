class profile::app::cloudshop::webapp::init (
  $dbserver      = $::hostname, # on Windows / AWS. $::fqdn doesn't work
  $dbinstance    = 'MYINSTANCE',
  $dbpass        = 'Azure$123',
  $dbuser        = 'CloudShop',
  $dbname        = 'AdventureWorks2012',
  $iis_site      = 'Default Web Site',
  $docroot       = 'C:/inetpub/wwwroot',
  $file_source   = 'https://s3-us-west-2.amazonaws.com/tseteam/files/sqlwebapp',
) {
  require profile::app::cloudshop::webapp::iis
  file { "${docroot}/CloudShop":
    ensure  => directory,
  }
  staging::file { 'CloudShop.zip':
    source => "${file_source}/CloudShop.zip",
  }
  unzip { 'Unzip webapp CloudShop':
    source      => "${::staging_windir}/${module_name}/CloudShop.zip",
    creates     => "${docroot}/CloudShop/Web.config",
    destination => "${docroot}/CloudShop",
    require     => Staging::File['CloudShop.zip'],
  }
  file { "${docroot}/CloudShop/Web.config":
    ensure  => present,
    content => template('profile/cloudshop/Web.config.erb'),
    require => Unzip['Unzip webapp CloudShop'],
    notify  => Exec['ConvertAPP'],
  }
  exec { 'ConvertAPP':
    command     => "ConvertTo-WebApplication \'IIS:/Sites/${iis_site}/CloudShop\'",
    provider    => powershell,
    refreshonly => true,
  }
}

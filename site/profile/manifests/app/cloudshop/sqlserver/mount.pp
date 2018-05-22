# This class is used to mount an ISO containing the SQL Server 2014 Code.
class profile::app::cloudshop::sqlserver::mount (
  $iso = 'SQLServer2014-x64-ENU.iso',
  $iso_source = 'https://s3-us-west-2.amazonaws.com/tseteam/files/tse_sqlserver',
  $iso_drive = 'F'
) {
  include profile::app::cloudshop::sqlserver::staging

  staging::file { $iso:
    source  => "${iso_source}/${iso}",
    timeout => 600, # default 300
  }

  $iso_path = "${::staging::path}/${module_name}/${iso}"

  acl { $iso_path :
    permissions => [
      {
        identity => 'Everyone',
        rights   => [ 'full' ]
      },
      {
        identity => $::staging::owner,
        rights   => [ 'full' ]
      },
    ],
    require     => Staging::File[$iso],
    before      => Mount_iso[$iso_path],
  }

  mount_iso { $iso_path :
    drive_letter => $iso_drive,
  }

}

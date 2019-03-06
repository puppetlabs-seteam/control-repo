class profile::puppet::master::fileserver::jdk (
  $srv_root = '/opt/tse-files',
) {
  file { "${srv_root}/jdk":
    ensure => directory,
    mode   => '0755',
  }

  file { "${srv_root}/jre":
    ensure => directory,
    mode   => '0755',
  }

  remote_file { 'jdk-8u45-windows-x64.exe':
    source  => 'https://s3-us-west-2.amazonaws.com/tseteam/files/jdk-8u45-windows-x64.exe',
    path    => "${srv_root}/jdk/jdk-8u45-windows-x64.exe",
    mode    => '0644',
    require => File["${srv_root}/jdk"],
  }

  remote_file { 'jre-8u131-windows-x64.exe':
    source  => 'https://s3-us-west-2.amazonaws.com/tseteam/files/jre-8u131-windows-x64.exe',
    path    => "${srv_root}/jre/jre-8u131-windows-x64.exe",
    mode    => '0644',
    require => File["${srv_root}/jre"],
  }

}

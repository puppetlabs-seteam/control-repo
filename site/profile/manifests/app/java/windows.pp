class profile::app::java::windows (
  $distribution,
){

  # Distribution Var to be implemented
  file { 'c:/temp':
    ensure => directory,
    before => Remote_file['c:/temp/jre-8u131-windows-x64.exe'],
  }

  remote_file { 'c:/temp/jre-8u131-windows-x64.exe':
    ensure => present,
    source => "http://${::puppet_server}:81/jre/jre-8u131-windows-x64.exe",
    #source => 'https://s3-us-west-2.amazonaws.com/tseteam/files/jre-8u131-windows-x64.exe',
    before => Package['Java 8 Update 131 (64-bit)'],
  }

  package { 'Java 8 Update 131 (64-bit)':
    ensure          => installed,
    source          => 'c:/temp/jre-8u131-windows-x64.exe',
    install_options => ['INSTALL_SILENT=Enable'],
  }

}

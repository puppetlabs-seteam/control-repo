class profile::app::puppet_tomcat::windows inherits profile::app::puppet_tomcat {

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
    before          => Remote_file["C:/apache-tomcat-${::profile::app::puppet_tomcat::tomcat_version}.exe"],
  }

  windows_firewall::exception { 'Tomcat':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '8080',
    display_name => 'Apache Tomcat Port',
    description  => 'Inbound rule for Tomcat',
  }

  remote_file { "C:/apache-tomcat-${::profile::app::puppet_tomcat::tomcat_version}.exe":
    ensure => present,
    #source => "https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-8.0.44.exe",
    source => "http://${::puppet_server}:81/tomcat/apache-tomcat-${::profile::app::puppet_tomcat::tomcat_version}.exe",
    before => Package["Apache Tomcat ${::profile::app::puppet_tomcat::tomcat_major_version}.0 Tomcat${::profile::app::puppet_tomcat::tomcat_major_version} (remove only)"],
  }

  $::profile::app::puppet_tomcat::tomcat_other_versions.each |String $version| {
    exec { "remove tomcat ${version}":
      command => "\"C:/Program Files/Apache Software Foundation/Tomcat ${version}.0/Uninstall.exe\" /S -ServiceName=tomcat${version}",
      unless  => "cmd.exe /c if exist \"C:\\Program Files\\Apache Software Foundation\\Tomcat ${version}.0\\Uninstall.exe\" (exit /b 1)",
      path    => 'C:\windows\system32;C:\windows',
      before  => Package["Apache Tomcat ${::profile::app::puppet_tomcat::tomcat_major_version}.0 Tomcat${::profile::app::puppet_tomcat::tomcat_major_version} (remove only)"],
    }
  }

  package { "Apache Tomcat ${::profile::app::puppet_tomcat::tomcat_major_version}.0 Tomcat${::profile::app::puppet_tomcat::tomcat_major_version} (remove only)":
    ensure          => present,
    source          => "C:/apache-tomcat-${::profile::app::puppet_tomcat::tomcat_version}.exe",
    install_options => ['/S'],
  }

  service { "tomcat${::profile::app::puppet_tomcat::tomcat_major_version}":
    ensure  => running,
    enable  => true,
    require => Package["Apache Tomcat ${::profile::app::puppet_tomcat::tomcat_major_version}.0 Tomcat${::profile::app::puppet_tomcat::tomcat_major_version} (remove only)"],
  }

  remote_file { "C:/Program Files/Apache Software Foundation/Tomcat ${::profile::app::puppet_tomcat::tomcat_major_version}.0/webapps/plsample-${::profile::app::puppet_tomcat::plsample_version}.war":
    ensure  => latest,
    source  => "http://${::puppet_server}:81/tomcat/plsample-${::profile::app::puppet_tomcat::plsample_version}.war",
    require => Service["tomcat${::profile::app::puppet_tomcat::tomcat_major_version}"],
  }
}

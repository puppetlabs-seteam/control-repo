class profile::app::puppet_tomcat (
  String  $plsample_version     = "1.0",
  String  $tomcat_major_version = "7",
) {

  #include profile::firewall

  case $tomcat_major_version {
    '6': {
      $tomcat_version = '6.0.44'
      $catalina_dir = "/opt/apache-tomcat6"
      $tomcat_other_versions = [ '7', '8']
    }
    '7': {
      $tomcat_version = '7.0.64'
      $catalina_dir = "/opt/apache-tomcat7"
      $tomcat_other_versions = [ '6', '8']
    }
    '8': {
      $tomcat_version = '8.0.26'
      $catalina_dir = "/opt/apache-tomcat8"
      $tomcat_other_versions = [ '6', '7']
    }
  }

  if $::kernel == 'Linux' {
    contain profile::app::puppet_tomcat::linux
    }
  elsif $::kernel == 'windows' {
    contain profile::app::puppet_tomcat::windows
    }
  }

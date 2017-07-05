class profile::app::webserver::iis (
  Boolean $default_website = true,
){

  if $::kernel != 'windows' {
    fail('Unsupported OS')
  }

  $iis_features = [
    'Web-Server',
    'Web-WebServer',
    'Web-Http-Redirect',
    'Web-Mgmt-Console',
    'Web-Mgmt-Tools',
  ]

  windowsfeature { $iis_features:
    ensure => present,
  }

  if $default_website != true {
    iis_site { 'Default Web Site':
      ensure => 'absent',
    }
  }

}

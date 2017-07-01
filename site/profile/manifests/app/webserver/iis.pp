class profile::app::webserver::iis (
  $default_website = 'present',
){

  $iis_features = [
    'Web-Server',
    'Web-WebServer',
    'Web-Http-Redirect',
    'Web-Mgmt-Console',
    'Web-Mgmt-Tools'
  ]

  windowsfeature { $iis_features:
    ensure => present,
  }

  iis::manage_site { 'Default Web Site':
    ensure => $default_website,
  }

}

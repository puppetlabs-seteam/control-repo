# @summary This profile installs IIS and turns off the default website
class profile::app::sample_website::iis {

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

  iis_site { 'Default Web Site':
    ensure => absent,
  }

}

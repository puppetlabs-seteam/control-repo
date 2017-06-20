class profile::platform::baseline::general::linux::ssh (
  String $permit_root_login = 'yes',
  Hash $packages   = {
    'openssh-server' => 'present',
    'openssh-client' => 'present',
  },
) {

  $packages.each |$p,$v| {
    package { $p:
      ensure => $v,
    }
  }

  class{'::ssh':
    permit_root_login => $permit_root_login,
    packages          => [], # Set the packages to blank so we can manage outside of the ssh class
    require           => [
      Package['openssh-server'],
      Package['openssh-client'],
    ],
  }

}

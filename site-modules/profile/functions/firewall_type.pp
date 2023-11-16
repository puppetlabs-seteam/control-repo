function profile::firewall_type(String $os, String $version) >> String {
  $os_firewalls = {
    'alma' => {
      '8' => 'firewalld',
      '9' => 'firewalld',
    },
    'centos' => {
      '7' => 'iptables',
      '8' => 'firewalld',
    },
    'oraclelinux' => {
      '7' => 'iptables',
      '8' => 'firewalld',
      '9' => 'firewalld',
    },
    'redhat' => {
      '7' => 'iptables',
      '8' => 'firewalld',
      '9' => 'firewalld',
    },
    'rocky' => {
      '8' => 'firewalld',
      '9' => 'firewalld',
    },
    'ubuntu' => {
      '20.04' => 'ufw',
      '22.04' => 'ufw',
    },
    'windows' => {
      '10'   => 'windows',
      '11'   => 'windows',
      '2016' => 'windows',
      '2019' => 'windows',
      '2022' => 'windows',
    },
  }

  if $os != undef and $version != undef {
    $firewall_type = $os_firewalls[$os.downcase()][$version]
  } else {
    ''
  }
}

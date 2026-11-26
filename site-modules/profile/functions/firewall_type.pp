function profile::firewall_type(String $os, String $version) >> String {
  $os_firewalls = {
    'amazon' => {
      '2023' => 'firewalld',
    },
    'almalinux' => {
      '8'  => 'firewalld',
      '9'  => 'firewalld',
      '10' => 'firewalld',
    },
    'oraclelinux' => {
      '8'  => 'firewalld',
      '9'  => 'firewalld',
      '10' => 'firewalld',
    },
    'redhat' => {
      '8'  => 'firewalld',
      '9'  => 'firewalld',
      '10' => 'firewalld',
    },
    'rocky' => {
      '8'  => 'firewalld',
      '9'  => 'firewalld',
      '10' => 'firewalld',
    },
    'ubuntu' => {
      '20.04' => 'ufw',
      '22.04' => 'ufw',
      '24.04' => 'ufw',
    },
    'windows' => {
      '10'   => 'windows',
      '11'   => 'windows',
      '2016' => 'windows',
      '2019' => 'windows',
      '2022' => 'windows',
      '2025' => 'windows',
    },
  }

  # Unknown OS or version returns '' so callers can skip the firewall instead of failing
  $os_firewalls.dig($os.downcase(), $version).lest || { '' }
}

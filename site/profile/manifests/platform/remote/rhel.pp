class profile::platform::remote::rhel {

  include profile::compliance::corp_std::rhel_ssh

  case $::operatingsystemmajrelease {
    '6': { $openssh_version = '5.3p1-112.el6_7' }
    '7': { $openssh_version = '6.6.1p1-22.el7' }
    default: { fail('unsupported operating system') }
  }

  package { 'openssh-server':
    ensure => $openssh_version,
    before => File['/etc/ssh/sshd_config'],
  }

}

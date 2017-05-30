class profile::compliance::corp_std {

  case $::osfamily {
    'RedHat': { include profile::compliance::corp_std::rhel }
    'Debian': { include profile::compliance::corp_std::debian }
    'windows': { include profile::compliance::corp_std::windows }
    default: { notify { 'unsupported operating system': } }
  }

}

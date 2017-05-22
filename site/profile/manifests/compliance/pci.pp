class profile::compliance::pci {

  case $::osfamily {
    'RedHat': { include profile::compliance::pci::rhel }
    'Debian': { include profile::compliance::pci::debian }
    'windows': { include profile::compliance::pci::windows }
    default: { notify { 'unsupported operating system' } }
  }

}

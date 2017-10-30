class profile::app::puppetdev {

  case $::kernel {

    'windows': {
      contain ::profile::app::puppetdev::windows
    }

    'Linux': {
      contain ::profile::app::puppetdev::linux
    }

    default: {
      fail('Unsupported OS')
    }

  }

}

class profile::app::puppetdev {

  case $facts['kernel'] {

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

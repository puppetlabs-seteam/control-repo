class profile::app::rubydev {

  case $::kernel {

    'windows': {
      contain ::profile::app::rubydev::windows
    }

    'Linux': {
      contain ::profile::app::rubydev::linux
    }

    default: {
      fail('Unsupported OS')
    }

  }

}

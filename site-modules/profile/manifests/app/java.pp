class profile::app::java (
  $distribution = 'jre',
){

  case $facts['kernel'] {

    'windows': {
      class{'::profile::app::java::windows':
        distribution => $distribution,
      }
    }

    'Linux': {
      class{'::profile::app::java::linux':
        distribution => $distribution,
      }
    }

    default:   {
      fail('Unsupported kernel detected')
    }

  }

}

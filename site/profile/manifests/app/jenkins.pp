class profile::app::jenkins (
  $master = true,
){

  case $master {
    true: {
      include ::profile::app::jenkins::master
    }
    default: {
      include ::profile::app::jenkins::slave
    }
  }

}

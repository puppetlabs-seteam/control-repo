class profile::app::java::linux (
  $distribution,
){

  class { '::java':
    distribution => $distribution,
  }

}

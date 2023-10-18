class profile::app::docker {

  if $facts['kernel'] == 'windows' {
    fail('Unsupported OS')
  }

  include ::docker

}

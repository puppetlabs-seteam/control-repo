class profile::app::jenkins::master {

  if $::kernel == 'windows' {
    fail('Unsupported OS')
  }

  docker::image { 'ipcrm/jenkins_demo':
    ensure    => present,
    image_tag => 'latest',
  }

  docker::run { 'jenkins_demo':
    image            => 'ipcrm/jenkins_demo:latest',
    ports            => ['8080:8080','50000:50000'],
    extra_parameters => [ '--restart=always' ],
  }

}

class example::dockerhost {

  require 'docker'

  file { '/tmp/DockerFile':
    source => 'puppet:///modules/example/DockerUbuntuApache',
  }

  docker::image { 'my_webserver':
    docker_file => '/tmp/DockerFile',
    subscribe   => File['/tmp/DockerFile'],
  }

  docker::run { 'webserver':
    ports => ['80:80'],
    image => 'my_webserver:latest',
  }

}

class profile::cd4pe {
  include docker
  
  docker::image { 'pcr-internal.puppet.net/pipelines/pfi':
    image_tag => 'latest',
  }
  
  docker::image { 'mysql':
    image_tag => '5.7',
  }
  
  docker::image { 'docker.bintray.io/jfrog/artifactory-oss':
    image_tag => '5.8.3',
  }
  
  docker_network { 'cd4pe-network':
    ensure      => 'present',
    driver      => 'bridge',
    ipam_driver => 'default',
    subnet      => '172.18.0.0/16',
  }
  
  docker::run { 'cd4pe-mysql':
    image   => 'mysql:5.7',
    net     => 'cd4pe-network',
    ports   => ['3306:3306'],
    volumes => ['cd4pe-mysql:/var/lib/mysql'],
    env     => [
      'MYSQL_ROOT_PASSWORD=puppetlabs',
      'MYSQL_DATABASE=cd4pe',
      'MYSQL_PASSWORD=puppetlabs',
      'MYSQL_USER=cd4pe',
    ],
  }
  
  docker::run { 'cd4pe-artifactory':
    image   => 'docker.bintray.io/jfrog/artifactory-oss:5.8.3',
    net     => 'cd4pe-network',
    ports   => ['8081:8081'],
    volumes => ['data_s3:/var/opt/jfrog/artifactory'],
  }
  
  docker::run { 'cd4pe':
    image   => 'pcr-internal.puppet.net/pipelines/pfi:latest',
    net     => 'cd4pe-network',
    ports   => ['8080:8080', '8000:8000', '7000:7000'],
    volumes => [
      'cd4pe-mysql:/var/lib/mysql',
      '/etc/hosts:/etc/hosts',
    ],
    env     => [
      'DB_ENDPOINT=mysql://cd4pe-mysql:3306/cd4pe',
      'DB_USER=cd4pe',
      'DB_PASS=puppetlabs',
      'DUMP_URI=dump://localhost:7000',
      'PFI_SECRET_KEY=5pM51Fu502mkPN3eKrHbvg==',
    ],
  }
}
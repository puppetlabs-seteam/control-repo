class profile::app::puppet_tomcat::linux inherits profile::app::puppet_tomcat {

  # tomcat starting takes 2-10 minutes currently due to /dev/random seed of entorpy. VM doesnt have much work
  # hence no entropy.

  class { 'java':
    distribution => 'jre'
  }

  class { '::tomcat':
    catalina_home => $::profile::app::puppet_tomcat::catalina_dir,
    before        => Class['java'],
  }

  firewall { '100 allow tomcat access':
    dport  => [8080],
    proto  => tcp,
    action => accept,
  }

  tomcat::instance{ "tomcat${profile::app::puppet_tomcat::tomcat_major_version}":
    install_from_source    => true,
    #source_url             => "https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-8.0.44.tar.gz",
    source_url             => "http://${::puppet_server}:81/tomcat/apache-tomcat-${::profile::app::puppet_tomcat::tomcat_version}.tar.gz",
    source_strip_first_dir => true,
    catalina_base          => $::profile::app::puppet_tomcat::catalina_dir,
    catalina_home          => $::profile::app::puppet_tomcat::catalina_dir,
    before                 => Tomcat::War["plsample-${::profile::app::puppet_tomcat::plsample_version}.war"],
  }

  tomcat::war { "plsample-${::profile::app::puppet_tomcat::plsample_version}.war" :
    #war_source    => "https://s3.amazonaws.com/saleseng/files/tomcat/sample-1.0.war",
    war_source    => "http://${::puppet_server}:81/tomcat/plsample-${::profile::app::puppet_tomcat::plsample_version}.war",
    catalina_base => $::profile::app::puppet_tomcat::catalina_dir,
    notify        => File["${::profile::app::puppet_tomcat::catalina_dir}/webapps/plsample"],
  }

  file { "${::profile::app::puppet_tomcat::catalina_dir}/webapps/plsample":
    ensure => 'link',
    target => "${::profile::app::puppet_tomcat::catalina_dir}/webapps/plsample-${::profile::app::puppet_tomcat::plsample_version}",
    notify => Tomcat::Service["plsample-tomcat${::profile::app::puppet_tomcat::tomcat_major_version}"],
  }

  $::profile::app::puppet_tomcat::tomcat_other_versions.each |String $version| {
    service {"tomcat-plsample-tomcat${version}":
      ensure => stopped,
      status => "ps aux | grep \'catalina.base=/opt/apache-tomcat${version}\' | grep -v grep",
      stop   => "su -s /bin/bash -c \'/opt/apache-tomcat${version}/bin/catalina.sh stop tomcat\'",
      before => File["/opt/apache-tomcat${version}"],
    }
    file {"/opt/apache-tomcat${version}":
      ensure => absent,
      force  => true,
      backup => false,
      before => Tomcat::Service["plsample-tomcat${::profile::app::puppet_tomcat::tomcat_major_version}"],
    }
  }

  tomcat::service { "plsample-tomcat${::profile::app::puppet_tomcat::tomcat_major_version}":
    catalina_base => $::profile::app::puppet_tomcat::catalina_dir,
    catalina_home => $::profile::app::puppet_tomcat::catalina_dir,
    service_name  => 'plsample',
    subscribe     => Tomcat::War["plsample-${::profile::app::puppet_tomcat::plsample_version}.war"],
  }

}

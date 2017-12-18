class profile::app::puppet_tomcat::linux (
  String $plsample_version,
  String $tomcat_version,
  String $catalina_dir,
  Array  $tomcat_other_versions,
) {

  include ::profile::app::entropy

  class {'::profile::app::java':
    distribution => 'jre',
  }

  class { '::tomcat':
    catalina_home => $catalina_dir,
    before        => Class['java'],
  }

  firewall { '100 allow tomcat access':
    dport  => [8080],
    proto  => tcp,
    action => accept,
  }

  tomcat::instance{ "tomcat${tomcat_version}":
    install_from_source    => true,
    source_url             => "https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-8.0.44.tar.gz",
    #source_url             => "http://${::puppet_server}:81/tomcat/apache-tomcat-${tomcat_version}.tar.gz",
    source_strip_first_dir => true,
    catalina_base          => $catalina_dir,
    catalina_home          => $catalina_dir,
    before                 => Tomcat::War["plsample-${plsample_version}.war"],
  }

  tomcat::war { "plsample-${plsample_version}.war" :
    #war_source    => "https://s3.amazonaws.com/saleseng/files/tomcat/sample-1.0.war",
    war_source    => "https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war",
    #war_source    => "http://${::puppet_server}:81/tomcat/plsample-${plsample_version}.war",
    catalina_base => $catalina_dir,
    notify        => File["${catalina_dir}/webapps/plsample"],
  }

  file { "${catalina_dir}/webapps/plsample":
    ensure => 'link',
    target => "${catalina_dir}/webapps/plsample-${plsample_version}",
    notify => Tomcat::Service["plsample-tomcat${tomcat_version}"],
  }

  $tomcat_other_versions.each |String $version| {
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
      before => Tomcat::Service["plsample-tomcat${tomcat_version}"],
    }
  }

  tomcat::service { "plsample-tomcat${tomcat_version}":
    catalina_base => $catalina_dir,
    catalina_home => $catalina_dir,
    service_name  => 'plsample',
    subscribe     => Tomcat::War["plsample-${plsample_version}.war"],
  }

}

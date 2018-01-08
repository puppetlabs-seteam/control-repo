class role::jenkins_master {

  include ::profile::platform::baseline
  include ::profile::app::docker
  include ::profile::app::jenkins::master

}

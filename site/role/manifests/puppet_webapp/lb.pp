class role::puppet_webapp::lb {

  include ::profile::platform::baseline
  include ::profile::app::puppet_webapp::lb

  Class['Profile::Platform::Baseline']
    -> Class['Profile::App::Puppet_webapp::Lb']
}

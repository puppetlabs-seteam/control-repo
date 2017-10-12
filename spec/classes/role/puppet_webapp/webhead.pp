class role::puppet_webapp::webhead {

  include ::profile::platform::baseline
  include ::profile::app::puppet_webapp::webhead

  Class['Profile::Platform::Baseline']
    -> Class['Profile::App::Puppet_webapp::Webhead']
}

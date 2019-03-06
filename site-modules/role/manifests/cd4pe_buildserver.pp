class role::cd4pe_buildserver {

  include profile::platform::baseline
  include profile::puppet::cd4pe_buildserver
  include profile::app::pipelines::agent
}

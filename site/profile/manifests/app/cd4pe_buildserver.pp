class profile::app::cd4pe_buildserver {
  include profile::app::cd4pe_buildserver::hosts
  case $::kernel {
    'Linux':   {  include ::profile::app::cd4pe_buildserver::linux }
    'windows': {  include ::profile::app::cd4pe_buildserver::windows }
    default:   { fail('Unsupported OS') }
  }
}
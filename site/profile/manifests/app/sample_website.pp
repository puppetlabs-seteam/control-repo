# @summary This profile installs a sample website
class profile::app::sample_website {
  if $::kernel == 'Linux' {
    include profile::app::sample_website::linux
  }
  elsif $::kernel == 'windows' {
    include profile::app::sample_website::windows
  }
  
}

class profile::platform::software::windows {

  require chocolatey

  # CORP PACKAGES
  Package {
    ensure   => installed,
    provider => chocolatey,
  }

  package { 'notepadplusplus': }
  package { '7zip': }
  package { 'git': }

}

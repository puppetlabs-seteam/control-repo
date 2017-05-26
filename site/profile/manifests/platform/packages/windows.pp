class profile::platform::packages::windows {

  # CORP PACKAGES
  Package {
    ensure   => installed,
    provider => chocolatey,
  }

  package { 'notepadplusplus': }
  package { '7zip': }
  package { 'git': }

}

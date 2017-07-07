class profile::platform::baseline::general::windows::packages {

  require ::chocolatey

  Package {
    ensure   => installed,
    provider => chocolatey,
  }

  package { 'notepadplusplus': }
  package { '7zip': }
  package { 'git': }
}

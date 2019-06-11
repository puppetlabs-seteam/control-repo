class profile::platform::baseline::windows::packages {

  Package {
    ensure   => 'present',
    provider => chocolatey,
  }

  package { 'notepadplusplus': }
  package { '7zip': }
  package { 'git': }
  package { 'uniextract': }

}

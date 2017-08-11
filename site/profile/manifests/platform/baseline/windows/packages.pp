class profile::platform::baseline::windows::packages {

  require ::chocolatey

  Package {
    ensure   => installed,
    provider => chocolatey,
  }

  package { 'notepadplusplus': }
  package { '7zip': }
  package { 'git': }
  package { 'uniextract': }

  # Get WMF 5.0
  package { 'powershell':
    ensure          => latest,
    install_options => ['-pre','--ignore-package-exit-codes'],
  }

}

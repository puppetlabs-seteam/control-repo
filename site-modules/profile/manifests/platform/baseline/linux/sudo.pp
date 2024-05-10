# Configure correct sudoers.d entries
class profile::platform::baseline::linux::sudo () {
  # Remove left behind entries from various deployment systems and OSes
  file { '/etc/sudoers.d/README': ensure => absent }
  file { '/etc/sudoers.d/vagrant': ensure => absent }
  file { '/etc/sudoers.d/90-cloud-init-users': ensure => absent }

  # Manage main sudoers file
  if !defined(Class['sce_linux']) {
    file { '/etc/sudoers':
      ensure  => file,
      content => epp('profile/sudo/sudoers.epp'),
    }
  }

  # Add entried for explicet sudo allowed users
  ['puppetadmin'].each | $user | {
    file { "/etc/sudoers.d/puppet-managed-${user}":
      ensure  => file,
      content => epp('profile/sudo/puppet-managed-user.epp', { 'user' => $user }),
    }
  }
}

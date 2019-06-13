# This is used for mocking the existence of PE resources for tests
service { 'pe-puppetserver':
  ensure => 'running'
}

#
class profile::app::sensu::checks::linux
{

  Sensu::Check {
    interval    => 30,
    standalone  => false,
    subscribers => [ 'linux' ],
  }

  sensu::check { 'diskspace':
    command     => 'check-disk-usage.rb -w :::disk.warning|80::: -c :::disk.critical|90::: -t ext2,ext3,ext4,xfs -i :::disk.ignore|none:::',
  }

  sensu::check { 'load':
    command     => 'check-load.rb -w :::load.warning|1.7,1.6,1.5::: -c :::load.critical|1.9,1.8,1.7:::',
  }

  sensu::check { 'memory':
    command     => 'check-memory-percent.rb -w :::memory.warning|85::: -c :::memory.critical|90:::',
  }

  sensu::check { 'dns':
    command     => 'check-dns.rb -d :::dns.domain|google.com:::',
  }

  sensu::check { 'apache':
    command     => 'check-http.rb -u http://localhost --response-code 200',
    interval    => 5,
    subscribers => [ 'apache' ],
  }

}

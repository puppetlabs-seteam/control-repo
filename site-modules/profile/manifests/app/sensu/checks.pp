# sensu checks
class profile::app::sensu::checks {

  include profile::app::sensu::checks::windows
  include profile::app::sensu::checks::linux

  Sensu::Check {
    interval    => 30,
    standalone  => false,
    subscribers => [ 'linux' ],
  }

  sensu::check { 'redis-slave-status':
    command     => 'check-redis-slave-status.rb',
    subscribers => [ 'sensu-server' ],
  }
  sensu::check { 'redis-memory':
    command     => 'check-redis-memory-percentage.rb -w :::redis.memwarn|80::: -c :::redis.memcrit|90:::',
    subscribers => [ 'sensu-server' ],
  }
  sensu::check { 'redis-ping':
    command     => 'check-redis-ping.rb ',
    subscribers => [ 'sensu-server' ],
  }

  sensu::check { 'rabbitmq-alive':
    command     => 'check-rabbitmq-alive.rb',
    subscribers => [ 'sensu-server' ],
  }

  sensu::check { 'rabbitmq-node-health':
    command     => 'check-rabbitmq-node-health.rb -m :::rabbitmq.memwarn|80::: -c :::rabbitmq.memcrit|90::: -f :::rabbitmq.fdwarn|80::: -F :::rabbitmq.fdcrit|90::: -s :::rabbitmq.socketwarn|80::: -S :::rabbitmq.socketcrit|90:::',
    subscribers => [ 'sensu-server' ],
  }

  sensu::check { 'rabbitmq-queue-drain-time':
    command     => 'check-rabbitmq-queue-drain-time.rb -w :::rabbitmq.queuewarn|180::: -c :::rabbitmq.queuecrit|360:::',
    subscribers => [ 'sensu-server' ],
  }
}

#
class profile::app::sensu::checks::windows
{

  Sensu::Check {
    interval    => 30,
    standalone  => false,
    subscribers => [ 'windows' ],
  }

  sensu::check { 'check-windows-cpu-load':
    command     => 'c:\\opt\\sensu\\embedded\\bin\\check-windows-cpu-load.rb.bat',
  }

  sensu::check { 'check-windows-ram':
    command     => 'c:\\opt\\sensu\\embedded\\bin\\check-windows-ram.rb.bat',
  }

  sensu::check { 'check-windows-disk':
    command     => 'c:\\opt\\sensu\\embedded\\bin\\check-windows-disk.rb.bat',
  }

  sensu::check { 'iis':
    command     => 'c:\\opt\\sensu\\embedded\\bin\\check-http.rb.bat -u http://localhost --response-code 200',
    interval    => 5,
    subscribers => [ 'iis' ],
  }

}

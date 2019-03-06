plan profile::rolling_update (
  $lb          = 'ubuntu1404a.pdx.puppet.vm',
  $app_servers = 'centos7b.pdx.puppet.vm',
  $backend     = 'dev_bk',
){

  profile::puts("Start perform rolling upgrade for backend ${backend} on ${lb}...")

  $app_servers.split(',').each |$a| {

    profile::puts("\tDrain connections from member ${backend}:${a}")
    if run_task('profile::haproxy', "pcp://${lb}",
      action  => drain,
      server  => $a.split('\.')[0],
      socket  => '/var/lib/haproxy/stats',
      backend => $backend,
    ).ok() == true {
      profile::puts("\tConnections from member ${backend}:${a} drained successfully!")
    } else {
      fail("\tCouldn't drain connections from member ${backend}:${a}!")
    }


    profile::puts("\tRunning update (via puppet) on ${a}...")
    $output = run_task('profile::puppetagent', "pcp://${a}")

    if $output.ok() == true {

      profile::puts("\n")
      $output.values[0]['message'].split('\n').each |$o| {
        profile::puts("\tpuppet-agent: ${o}")
      }
      profile::puts("\n")

    } else {
      fail("${a} failed to run Puppet, failing...")
    }


    profile::puts("\tRunning healthcheck on ${a}...")
    if run_task('profile::healthcheck', "pcp://${a}",
      port   => 8008,
      target => $a,
    ).ok() == true {
      profile::puts("\tSuccessfully updated ${a}!")
    } else {
      fail("\tHealthcheck failed for ${a}!")
    }


    profile::puts("\tRe-addding ${a} to backend ${backend}...")
    if run_task('profile::haproxy', "pcp://${lb}",
      action  => add,
      server  => $a.split('\.')[0],
      socket  => '/var/lib/haproxy/stats',
      backend => $backend,
    ).ok() == true {
      profile::puts("\tRe-addded ${a} to backend ${backend} successfully!")
    } else {
      fail("\tFailed to re-add ${a} to backend ${backend}!")
    }


  }

  profile::puts("Finished performing rolling upgrade for backend ${backend} on ${lb}!")



}

#!/opt/puppetlabs/puppet/bin/ruby

require 'puppet'
require 'json'
require 'open3'

begin
  cmd_string = "/opt/puppetlabs/bin/puppet agent -t"
  _,stdout,stderr,wait_thr = Open3.popen3(cmd_string)
  raise Puppet::Error, stderr if ([wait_thr.value.exitstatus] & [0,2]).empty?
  puts({ status: 'success', message: stdout.readlines.join(''), resultcode: wait_thr.value.exitstatus }.to_json)
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', message: "#{e.message}\n#{stderr.readlines.join('')}", resultcode: wait_thr.value.exitstatus }.to_json)
  exit 1
end

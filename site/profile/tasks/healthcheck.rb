#!/opt/puppetlabs/puppet/bin/ruby

require 'net/http'
require 'uri'
require 'json'

params = JSON.parse(STDIN.read)
target = URI("http://#{params['target']}:#{params['port']}")

begin
  resp= Net::HTTP::get_response(target)
  success = resp.code == '200'
  result =  { :success => success, status: resp.code }
  puts result.to_json
rescue Exception => e
  success = false
  result =  {success: false, _error: {kind: 'haproxy/request_failed', msg: e.message}}
  puts result.to_json
end
if success
  exit 0
else
  exit 1
end

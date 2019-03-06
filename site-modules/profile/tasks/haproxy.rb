#!/opt/puppetlabs/puppet/bin/ruby

require 'socket'
require 'json'

class TaskError < ArgumentError
  attr_reader :details

  def initialize(msg, details = nil)
    @details = details || {}
    super(msg)
  end

  def get_result
    { _error: {
        kind: "haproxy-error",
        msg: @message,
        details: @details
      }
    }
  end
end

def socket_command(path, cmd)
  result = []
  UNIXSocket.open(path) do |socket|
    socket.puts(cmd)
    while line = socket.gets
      result.push(line) unless line == "\n"
    end
  end

  if result[0] =~ /Unknown command/
    raise TaskError.new("Unkown HAProxy command: #{cmd}", {command: cmd})
  end

  return result
end

def get_stat(socket, backend, server, stat)
  stats = socket_command(socket, 'show stat').map { |l| l.split(',') }

  idx = stats[0].index(stat)
  raise TaskError.new("Could not find stat: #{stat}", {stats: stats}) unless idx

  row = stats.index { |r| r[0] == backend && r[1] == server }
  raise TaskError.new("Could not find entry for: #{backend}/#{server}", {stats: stats}) unless row

  stats[row][idx]
end

def set_state(socket, backend, server, state)
  cmd = "set server #{backend}/#{server} state #{state}"
  r = socket_command(socket, cmd)
  raise TaskError.new("Failed to set #{state} state: #{r[0]}", {result: r.join("\n")}) unless r.empty?
end

def wait_for_empty(socket, backend, server, timeout)
  conns = 1
  count = 0
  while conns > 0 and count < timeout
    conns = get_stat(socket, backend, server, 'scur').to_i
    sleep(1)
    count += 1
  end
  return conns
end

def get_param(params, key)
  unless val = params[key]
    raise TaskError.new("Missing required key '#{key}' for #{params['action']}.", {key: key})
  end
  val
end

def run_action(params)
  action = params['action']
  socket = params['socket']
  if action == 'command'
    cmd = get_param(params, 'command')
    return { result: socket_command(socket, cmd) }
  else
    backend = get_param(params, 'backend')
    server = get_param(params, 'server')
    case action
    when 'drain'
      set_state(socket, backend, server, 'drain')
      return {success: true}
    when 'add'
      set_state(socket, backend, server, 'ready')
      return {success: true}
    when 'drain_wait'
      timeout = params['timeout'] || 60
      set_state(socket, backend, server, 'drain')
      conns = wait_for_empty(socket, backend, server, timeout)
      return {success: conns == 0, conns: conns }
    when 'get_stat'
      stat = get_param(params, 'stat')
      return {stat_val: get_stat(socket, backend, server, stat)}
    end
  end
  # metadata should prevent this
  raise TaskError.new("Unknown action: #{action}")
end


begin
  params = JSON.parse(STDIN.read)
  result = run_action(params)
end

puts result.to_json

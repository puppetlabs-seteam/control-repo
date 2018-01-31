Puppet::Functions.create_function(:'profile::puts') do
  dispatch :pts do
    param 'String', :msg
  end

  def pts(msg)
    time = Time.new
    puts "#{time.inspect}: #{msg}"
  end
end

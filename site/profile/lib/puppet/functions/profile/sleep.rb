Puppet::Functions.create_function(:'profile::sleep') do
  dispatch :chill do
    param 'Integer', :seconds
  end

  def chill(seconds)
    time = Time.new
    puts "#{time.inspect}: NOTICE Sleeping for #{seconds} seconds..."
    sleep(seconds)
  end
end

Puppet::Functions.create_function(:'profile::loaddata') do
  dispatch :getdata do
    param 'String', :file
  end

  def getdata(file)
    lf = YAML.load_file(file)
    lf
  end
end

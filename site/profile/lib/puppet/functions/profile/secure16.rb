require 'securerandom'
Puppet::Functions.create_function(:'profile::secure16') do
  def secure16
    SecureRandom.base64(n=16)
  end
end

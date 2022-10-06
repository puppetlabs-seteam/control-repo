Facter.add(:info) do
  setcode do
    kernel = Facter.value(:kernel)
    case kernel
    when 'Linux'
      Facter::Core::Execution.exec('cat /etc/puppetlabs/puppet/info.txt')
    when 'windows'
      file = File.open("C:\\ProgramData\\PuppetLabs\\puppet\\info.txt")
      file.read
    else
      'production'
    end  
  end
end

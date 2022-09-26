Facter.add(:info) do
  setcode do
    Facter::Core::Execution.exec('cat /etc/puppetlabs/puppet/info.txt')
  end
end

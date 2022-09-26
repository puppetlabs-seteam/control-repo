Facter.add(:info) do
  confine :osfamily => 'RedHat'
  confine :operatingsystemmajrelease => '7'
  setcode do
    Facter::Core::Execution.exec('cat /etc/puppetlabs/puppet/info.txt')
  end
end

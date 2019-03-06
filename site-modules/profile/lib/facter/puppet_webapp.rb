# Get Webapp version, if installed
Facter.add(:puppet_webapp) do
  confine :kernel => 'Linux'
  setcode do
    ret = Facter::Util::Resolution.exec('python -c "import pkg_resources; print pkg_resources.get_distribution(\'puppet_webapp\').version" 2>/dev/null')
    if ret.to_s.strip.empty?
      nil
    else
      ret
    end
  end
end

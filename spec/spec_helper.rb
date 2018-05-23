require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'simplecov'
require 'simplecov-console'

begin
  require 'spec_helper_local' if File.file?(File.join(File.dirname(__FILE__), 'spec_helper_local.rb'))
rescue LoadError => loaderror
  warn "Could not require spec_helper_local: #{loaderror.message}"
end

include RspecPuppetFacts

# Custom Facts
add_custom_fact :is_pe, 'true'
add_custom_fact :pe_version, nil
add_custom_fact :pe_server_version, '2017.2.1'
add_custom_fact :puppet_server, 'master.test.com'
add_custom_fact :networking, {'ip' => '127.0.0.1'}
add_custom_fact :appenv, 'dev'
add_custom_fact :memory, {
  "system" => {
    "used" => "7.37 GiB",
    "total" => "15.51 GiB",
    "capacity" => "47.48%",
    "available" => "8.15 GiB",
    "used_bytes" => 7910199296,
    "total_bytes" => 16658804736,
    "available_bytes" => 8748605440
  }
}

if !Gem.win_platform?
  add_custom_fact :staging_http_get,    'curl'
  add_custom_fact :ssh_version,         'OpenSSH_6.6.1p1'
  add_custom_fact :ssh_version_numeric, '6.6.1'
  add_custom_fact :gogs_version,        '0.11.19'
  add_custom_fact :jenkins_plugins, nil
  add_custom_fact :root_home, '/root'
  add_custom_fact :osreleasemaj,           '$::os.release.major'  
  add_custom_fact :pygpgme_installed,           'true'  
else
  add_custom_fact :choco_install_path,     'C:\ProgramData\chocolatey'
  add_custom_fact :chocolateyversion,      '0.10.7'
  add_custom_fact :archive_windir,         'C:\ProgramData\staging'
  add_custom_fact :staging_windir,         'C:\ProgramData\staging'
  add_custom_fact :operatingsystemversion, 'Windows Server 2012 R2 Standard'
  add_custom_fact :staging_http_get,       'powershell'
  add_custom_fact :iis_version,            '8.5'
  add_custom_fact :powershell_version,     '5.1.14409'
end


supported_os = on_supported_os.keys
if Gem.win_platform?
  SUPPORTED_OS = on_supported_os.delete_if { |k,v| !k.to_s.match(/windows/i) }
else
  SUPPORTED_OS = on_supported_os.delete_if { |k,v| k.to_s.match(/windows/i) }
end
puts "WARNING: Ommiting the following supported OS from this test run: #{(supported_os - SUPPORTED_OS.keys).join(',')}"

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ])
end

base_dir = File.dirname(File.expand_path(__FILE__))

RSpec.configure do |c|
  # Readable test descriptions
  c.warnings  = false  
  c.formatter = :documentation
  c.color     = true
  c.manifest_dir    = File.join(base_dir, 'fixtures', 'modules', 'manifests')
  c.manifest        = File.join(base_dir, 'fixtures', 'modules', 'manifests', 'site.pp')
end




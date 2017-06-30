require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'simplecov'
require 'simplecov-console'

include RspecPuppetFacts

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

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
  c.color     = true
end

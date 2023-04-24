source 'https://rubygems.org'

ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = ruby_version_segments[0..1].join('.')

group :development do
  # gem 'onceover', git: 'git@github.com:dylanratcliffe/onceover.git', branch: 'formatter_factset'
  gem 'onceover', '3.20.0'
  gem 'onceover-codequality', '0.9.0'
  gem 'pry'
  gem 'rake', '13.0.6'
  gem 'ra10ke'
  gem 'rest-client'
  gem 'puppet', '7.21.0'
  gem 'puppet-syntax', '3.2.1'
  gem 'fast_gettext', '~> 2.3'
  # gem 'rspec', '3.8.0'
  # gem 'rspec-core', '3.8.0'
  # gem 'rspec-mocks', '=3.8.1'
  # gem 'rspec-expectations', '3.8.4'
  # gem 'rspec-support', '3.8.2'
  # gem 'facter', '2.5.7'
  gem "puppet-module-posix-default-r#{minor_version}", '~> 1.1', require: false, platforms: [:ruby]
  gem "puppet-module-posix-dev-r#{minor_version}", '~> 1.1',     require: false, platforms: [:ruby]
  gem 'rubocop', '~> 1.50'
  gem 'rubocop-rspec', '2.20.0'
  # gem 'puppetlabs_spec_helper'
end

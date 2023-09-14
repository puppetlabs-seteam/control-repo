source 'https://rubygems.org'

ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = ruby_version_segments[0..1].join('.')

group :development do
  # gem 'onceover', git: 'git@github.com:dylanratcliffe/onceover.git', branch: 'formatter_factset'
  gem 'onceover', '3.21.0'
  gem 'onceover-codequality', '0.8.0'
  gem 'pry'
  gem 'rake', '13.0.6'
  gem 'ra10ke'
  gem 'rest-client'
  gem 'puppet', '8.2'
  gem 'puppet-syntax', '3.3.0'
  gem 'fast_gettext', '~> 2.3'
  gem 'rspec', '3.12.0'
  # gem 'rspec-core', '3.8.0'
  # gem 'rspec-mocks', '=3.8.1'
  # gem 'rspec-expectations', '3.8.4'
  # gem 'rspec-support', '3.8.2'
  # gem 'facter', '2.5.7'
  gem "puppet-module-posix-default-r2.7", '~> 1.1.1', require: false, platforms: [:ruby]
  gem "puppet-module-posix-dev-r2.7", '~> 1.1.1',     require: false, platforms: [:ruby]
  gem 'puppet-strings', '>= 2'
  gem 'rubocop', '~> 1.6.1'
  gem 'rubocop-rspec', '2.0.1'
  # gem 'puppetlabs_spec_helper'
end

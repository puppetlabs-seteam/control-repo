source 'https://rubygems.org'

ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = ruby_version_segments[0..1].join('.')

group :development do
  # gem 'onceover', git: 'git@github.com:dylanratcliffe/onceover.git', branch: 'formatter_factset'
  gem 'onceover', '3.13.4'
  gem 'onceover-codequality'
  gem 'pry'
  gem 'ra10ke'
  gem 'rest-client'
  # gem 'rspec', '3.8.0'
  # gem 'rspec-core', '3.8.0'
  # gem 'rspec-mocks', '=3.8.1'
  # gem 'rspec-expectations', '3.8.4'
  # gem 'rspec-support', '3.8.2'
  gem 'facter', '2.5.1'
  gem "puppet-module-posix-default-r#{minor_version}", '~> 0.4', require: false, platforms: [:ruby]
  gem "puppet-module-posix-dev-r#{minor_version}", '~> 0.4',     require: false, platforms: [:ruby]
  # gem 'rubocop', '0.49.0'
  # gem 'rubocop-rspec'
  # gem 'rubocop-i18n'
  # gem 'puppetlabs_spec_helper'
  # gem 'puppet-syntax'
end

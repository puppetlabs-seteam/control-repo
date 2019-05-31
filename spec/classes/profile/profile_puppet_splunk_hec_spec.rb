require 'spec_helper'

describe 'profile::puppet::splunk_hec' do
    let(:pre_condition) do
      # This mocks the Service[pe-puppetserver] resource so that the class may be tested
      'service { "pe-puppetserver":
        ensure => running
      }'
    end

    before(:each) do
      Puppet::Parser::Functions.newfunction(:puppetdb_query, :type => :rvalue) do |args|
        [{'key' => 'certname','value'=> 'foo.example.com'}]
      end
    end

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :puppet_config => '/etc/puppetlabs/puppet/puppet.conf'
          })
        end

        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end
      end
    end

end

require 'spec_helper'

describe 'profile::puppet::splunk_hec' do
    let(:pre_condition) do
      # This mocks the Service[pe-puppetserver] resource so that the class may be tested
      'service { "pe-puppetserver":
        ensure => running
      }
      define pe_ini_setting (
        $ensure = present,
        $path,
        $section,
        $setting,
        $value,
      ) {
      }'
    end

    before(:each) do
      Puppet::Parser::Functions.newfunction(:puppetdb_query, :type => :rvalue) do |args|
        [{'key' => 'certname','value' => 'foo.example.com'}]
      end

      node_group_value = {
        "PE Master"=>{
          "environment_trumps"=>false,
          "parent"=>"00000000-0000-4000-8000-000000000000",
          "name"=>"All Nodes",
          "rule"=>["and", ["~", "name", ".*"]],
          "variables"=>{}, "id"=>"00000000-0000-4000-8000-000000000000",
          "environment"=>"production",
          "classes"=>{},
          "config_data"=>{}
        }
      }

      Puppet::Parser::Functions.newfunction(:node_groups, :type => :rvalue) do |args|
        node_group_value
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

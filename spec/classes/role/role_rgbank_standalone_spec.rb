require 'spec_helper'

describe 'role::rgbank_standalone' do

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        before(:each) do
          Puppet::Parser::Functions.newfunction(:puppetdb_query, :type => :rvalue) do |args|
            [{'facts'=>{'fqdn'=> 'testserver'}}]
          end
        end

        if facts[:osfamily] != 'RedHat'
          context "unsupported OS" do
            it { is_expected.to compile.and_raise_error(/Unsupported OS/)  }
          end
        else
          context "without any parameters" do
            it { is_expected.to compile.with_all_deps }
          end
        end

      end
    end

end

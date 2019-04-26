require 'spec_helper'

describe 'profile::puppet::splunk_hec' do
    let(:pre_condition) do
      # This mocks the Service[pe-puppetserver] resource so that the class may be tested
      'service { "pe-puppetserver":
        ensure => running
      }'
    end

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end
      end
    end

end

require 'spec_helper'

describe 'profile::infrastructure::splunk::splunk_server' do

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({:service_provider => 'systemd'})
        end

        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end
      end
    end

end

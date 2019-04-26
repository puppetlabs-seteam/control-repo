require 'spec_helper'

describe 'profile::infrastructure::splunk::splunk_server' do

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "without any parameters" do
          it { is_expected.to compile }
        end
      end
    end

end

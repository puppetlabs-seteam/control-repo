require 'spec_helper'

describe 'profile::puppet::seteam_master' do
    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        let(:pre_condition) {'
          service { "pe-puppetserver":
            ensure     => "running",
          }
        '}

        if facts[:kernel] != 'Linux'
          context "unsupported OS" do
            it { is_expected.to compile.and_raise_error(/Unsupported OS/)  }
          end
        else
          context "without any parameters" do
            it { is_expected.to compile }
          end
        end

      end
    end
end

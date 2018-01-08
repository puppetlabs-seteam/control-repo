require 'spec_helper'

describe 'role::jenkins_slave' do

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        if facts[:kernel] == 'Linux'
          if facts[:os]['family'] == 'RedHat'
            facts[:systemd] = true
          elsif (facts[:os]['name'] == 'Ubuntu') and (facts[:os]['major'].to_i < 16)
            facts[:systemd] = false
          elsif (facts[:os]['name'] == 'Ubuntu') and (facts[:os]['major'].to_i >= 16)
            facts[:systemd] = true
          else
            fail 'Unknown Linux Variant for Systemd fact'
          end
        end

        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end

      end
    end

end

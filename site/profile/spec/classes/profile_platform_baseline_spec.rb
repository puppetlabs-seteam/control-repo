require 'spec_helper'

describe 'profile::platform::baseline' do

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        # Fact Stubs
        facts[:ssh_version] = 'OpenSSH_6.6.1p1'
        facts[:ssh_version_numeric] = '6.6.1'
        facts[:choco_install_path] = 'C:\ProgramData\chocolatey'
        facts[:chocolateyversion] = '0.10.7'
        facts[:archive_windir] = 'C:\ProgramData\staging'

        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end
      end
    end

end

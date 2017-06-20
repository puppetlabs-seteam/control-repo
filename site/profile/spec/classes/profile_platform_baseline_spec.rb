require 'spec_helper'

describe 'profile::platform::baseline' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        facts[:ssh_version] = 'OpenSSH_6.6.1p1'
        facts[:ssh_version_numeric] = '6.6.1'

        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end

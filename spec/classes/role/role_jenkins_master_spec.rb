require 'spec_helper'

describe 'role::jenkins_master' do

    SUPPORTED_OS.select do |k,v|
      # Docker is supported on CentOS 7 or newer, and not CentOS 6
      !k.to_s.match(/centos-6/)
    end.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        if facts[:kernel] != 'Linux'
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

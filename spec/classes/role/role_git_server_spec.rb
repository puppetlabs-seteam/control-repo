require 'spec_helper'

describe 'role::git_server' do
  SUPPORTED_OS.each do |os, facts|
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

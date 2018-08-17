require 'spec_helper'

describe 'profile::app::gitlab' do
  SUPPORTED_OS.each do |os, facts|

    context "on #{os}" do
      let(:facts) do
        facts
      end

      if facts[:kernel] == 'Linux'
        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }
        end
      else
        context "unsupported OS" do
          it { is_expected.to compile.and_raise_error(/Unsupported OS/)  }
        end
      end

    end
  end
end

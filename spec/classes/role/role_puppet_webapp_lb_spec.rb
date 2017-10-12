require 'spec_helper'

describe 'role::puppet_webapp::lb' do

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        if Gem.win_platform?
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

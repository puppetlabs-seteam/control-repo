require 'spec_helper'

describe 'role::cloudshop' do

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        if Gem.win_platform?
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

require 'spec_helper'

describe 'profile::app::jenkins' do

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
            it { is_expected.to compile }
          end
        end

      end
    end

end

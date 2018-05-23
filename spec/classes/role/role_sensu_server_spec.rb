require 'spec_helper'

describe 'role::sensu_server' do

    SUPPORTED_OS.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        if Gem.win_platform?
          context "unsupported OS" do
            it { is_expected.to compile.and_raise_error(/Error/)  }
          end
        elsif facts[:os]['name'] == 'Ubuntu'
          context "unsupported OS" do
            it { is_expected.to compile.and_raise_error(/Error/)  }
          end          
        else
          context "without any parameters" do
            it { is_expected.to compile.with_all_deps }
          end
        end

      end
    end

end

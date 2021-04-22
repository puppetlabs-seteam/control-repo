Puppet::Functions.create_function(:'deployments::get_running_stage') do
  def get_running_stage # rubocop:disable Style/AccessorMethodName
    ENV.each do |env_var|
      if env_var[0].start_with?('CD4PE_STAGE_') && env_var[1] == 'RUNNING'
        matches = env_var[0].match(%r{^CD4PE_STAGE_(.+?)_.+$})
        return matches[1].to_s
      end
    end
  end
end

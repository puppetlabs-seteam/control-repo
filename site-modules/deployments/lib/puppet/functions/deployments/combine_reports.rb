Puppet::Functions.create_function(:'deployments::combine_reports') do
  dispatch :combine_reports do
    required_param 'Hash', :stage_report
    required_param 'Hash', :scm_data
    required_param 'Tuple', :ia_envs_report
  end

  def combine_reports(stage_report, scm_data, ia_envs_report)
    report = stage_report.merge(scm_data)
    ia_envs_report.each do |ia_env_report|
      report['log'] = report['log'] + "\n" + ia_env_report['log']
      report['notes'].append(ia_env_report['notes'])
    end
    report
  end
end

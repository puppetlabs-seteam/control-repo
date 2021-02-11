Puppet::Functions.create_function(:'deployments::report_impact_analysis') do
  dispatch :report_impact_analysis do
    required_param 'Hash', :impact_analysis
  end

  def report_impact_analysis(impact_analysis)
    report = {}
    report['log'] = ''
    report['results'] = []
    report['id'] = impact_analysis['id']
    report['state'] = impact_analysis['state']
    impact_analysis['results'].each do |env_result|
      result_report = {}
      result_report['IA_environment'] = env_result['environment']
      result_report['IA_resultId'] = env_result['environmentResultId']
      result_report['IA_nodeGroupId'] = env_result['nodeGroupId']
      result_report['IA_state'] = env_result['state']
      result_report['IA_totalNodeCount'] = env_result['totalNodeCount']
      result_report['IA_totalResourceChangeCount'] = env_result['totalResourceChangeCount']
      report['results'].append(result_report)
    end
    report
  end
end

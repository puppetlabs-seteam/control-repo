# frozen_string_literal: true

Puppet::Functions.create_function(:'deployments::report_impacted_nodes') do
  dispatch :report_impacted_nodes do
    required_param 'Hash', :ia_env_report
    required_param 'Hash', :impacted_nodes
    required_param 'Integer', :max_changes_per_node
  end

  def add2log(content)
    print(content + "\n")
    @report['log'] = if @report['log'] == ''
                       content
                     else
                       @report['log'] + "\n" + content
                     end
  end

  def report_impacted_nodes(ia_env_report, impacted_nodes, max_changes_per_node)
    @report = {}
    @report['log'] = ''
    @report['notes'] = {}
    ia_report = {}
    ia_report['IA_environment'] = ia_env_report['IA_environment']
    ia_report['IA_resultId'] = ia_env_report['IA_resultId']
    ia_report['IA_nodeGroupId'] = ia_env_report['IA_nodeGroupId']
    ia_report['IA_state'] = ia_env_report['IA_state']
    ia_report['IA_totalNodeCount'] = ia_env_report['IA_totalNodeCount']
    ia_report['IA_totalResourceChangeCount'] = ia_env_report['IA_totalResourceChangeCount']
    ia_report['IA_node_reports'] = {}
    ia_report['IA_nodes_impacted'] = impacted_nodes['rows'].count
    compile_failures = 0
    compile_success = 0
    add2log('  Impact Analysis Environment Report: ' + ia_report['IA_environment'])
    add2log('   Analysis status: ' + ia_report['IA_state'])
    unless impacted_nodes['rows'].count.zero?
      add2log('   Affected Node Report: ')
    end
    bln_safe_report = ia_report['IA_state'] == 'DONE'
    impacted_nodes['rows'].each do |node_result|
      ia_report['IA_node_reports'][node_result['certnameLowercase']] = {}
      if node_result.fetch('compileFailed', false)
        add2log('    Node ' + node_result['certnameLowercase'] + ': Failed compilation')
        compile_failures += 1
        ia_report['IA_node_reports'][node_result['certnameLowercase']]['Compilation'] = 'FAILED'
        bln_safe_report = false
      else
        add2log('    Node ' + node_result['certnameLowercase'] + ' resources: ' +
          node_result['resourcesAdded'].count.to_s + ' added, ' +
          node_result['resourcesModified'].count.to_s + ' modified, ' +
          node_result['resourcesRemoved'].count.to_s + ' removed.')
        compile_success += 1
        ia_report['IA_node_reports'][node_result['certnameLowercase']]['compilation'] = 'SUCCESS'
        ia_report['IA_node_reports'][node_result['certnameLowercase']]['resourcesAdded'] = node_result['resourcesAdded'].count.to_i
        ia_report['IA_node_reports'][node_result['certnameLowercase']]['resourcesModified'] = node_result['resourcesModified'].count.to_i
        ia_report['IA_node_reports'][node_result['certnameLowercase']]['resourcesRemoved'] = node_result['resourcesRemoved'].count.to_i
        ia_report['IA_node_reports'][node_result['certnameLowercase']]['totalResourcesChanges'] = (
          node_result['resourcesAdded'].count.to_i +
          node_result['resourcesModified'].count.to_i +
          node_result['resourcesRemoved'].count.to_i
        )
        if ia_report['IA_node_reports'][node_result['certnameLowercase']]['totalResourcesChanges'] > max_changes_per_node
          ia_report['IA_node_reports'][node_result['certnameLowercase']]['change_verdict'] = 'unsafe'
          bln_safe_report = false
        else
          ia_report['IA_node_reports'][node_result['certnameLowercase']]['change_verdict'] = 'safe'
        end
      end
    end
    ia_report['IA_compile_failures'] = compile_failures
    ia_report['IA_compile_success'] = compile_success
    if bln_safe_report == true
      ia_report['IA_verdict'] = 'safe'
      add2log('   Impact Analysis: safe')
    else
      ia_report['IA_verdict'] = 'unsafe'
      add2log('   Impact Analysis: unsafe')
    end
    @report['notes'] = ia_report
    @report
  end
end

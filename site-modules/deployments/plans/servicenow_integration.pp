plan deployments::servicenow_integration(
  String $snow_endpoint,
  String $snow_username,
  String $snow_password,
  String $stage_to_promote_to = undef,
  Optional[Integer] $max_changes_per_node = 10,
  Optional[String] $report_stage = 'Impact Analysis',
  Optional[String] $assignment_group = 'Change Management',
  Optional[String] $connection_alias = 'Puppet_Code',
  Optional[Boolean] $auto_create_ci = false,
){
  # Read relevant CD4PE environment variables
  $repo_type         = system::env('REPO_TYPE')
  $commit_sha        = system::env('COMMIT')
  $control_repo_name = system::env('CONTROL_REPO_NAME')
  $module_name       = system::env('MODULE_NAME')

  $repo_name = $repo_type ? {
    'CONTROL_REPO' => $control_repo_name,
    'MODULE' => $module_name
  }

  # Parse $snow_endpoint
  if $snow_endpoint == undef {
    fail_plan('No ServiceNow endpoint specified!', 'no_endpoint_error')
  } else {
    $_snow_endpoint = $snow_endpoint[0,8] ? {
      'https://' => $snow_endpoint,
      default    => "https://${snow_endpoint}"
    }
  }

  # Set the stage number if we need to auto-detect it
  unless $report_stage {
    $stage_num = deployments::get_running_stage()
  }

  # Find the pipeline ID for the commit SHA
  $pipeline_id_result = cd4pe_deployments::search_pipeline($repo_name, $commit_sha)
  $pipeline_id = cd4pe_deployments::evaluate_result($pipeline_id_result)

  # Loop until items in the pipeline stage are done
  $loop_result = ctrl::do_until('limit'=>80) || {
    # Wait 15 seconds for each loop
    ctrl::sleep(15)
    # Get the current pipeline stage status (temporary variables that don't exist outside this loop)
    $pipeline_result = cd4pe_deployments::get_pipeline_trigger_event($repo_name, $pipeline_id, $commit_sha)
    $pipeline = cd4pe_deployments::evaluate_result($pipeline_result)
    # If $report_stage is set, set the stage number by searching the pipeline output
    if $report_stage {
      $stage = $pipeline['stageNames'].filter |$stagenumber,$stagename| { $stagename == $report_stage }
      unless $stage.length == 1 {
        fail_plan("Provided report_stage '${report_stage}' could not be found in pipeline. \
        If you manually promoted the pipeline, please ensure you promote at a point that \
        includes the stage to report on!", 'stage_not_found_error')
      }
      $stage_num = $stage.keys[0]
    }
    # Check if items in the pipeline stage are done
    deployments::pipeline_stage_done($pipeline['eventsByStage'][$stage_num])
  }
  unless $loop_result {
    fail_plan('Timeout waiting for pipeline stage to finish!', 'timeout_error')
  }
  # Now that the relevant jobs in the pipeline stage have completed, generate the final pipeline variables
  $pipeline_result = cd4pe_deployments::get_pipeline_trigger_event($repo_name, $pipeline_id, $commit_sha)
  $pipeline = cd4pe_deployments::evaluate_result($pipeline_result)
  # If $report_stage is set, set the stage number by searching the pipeline output
  if $report_stage {
    $stage = $pipeline['stageNames'].filter |$stagenumber,$stagename| { $stagename == $report_stage }
    $stage_num = $stage.keys[0]
  }

  # Gather pipeline stage reporting
  $scm_data = deployments::report_scm_data($pipeline)
  $stage_report = deployments::report_pipeline_stage($pipeline, $stage_num, $repo_name)

  # See if the stage contains an Impact Analysis
  $ia_events = $stage_report['build']['events'].filter |$event| { $event['eventType'] == 'IA' }
  if $ia_events.length > 0 {
    # Get the Impact Analysis information
    $impact_analysis_id = $ia_events[0]['eventNumber']
    $impact_analysis_result = cd4pe_deployments::get_impact_analysis($impact_analysis_id)
    $impact_analysis = cd4pe_deployments::evaluate_result($impact_analysis_result)
    $ia_url = "${impact_analysis['baseTaskUrl']}/${impact_analysis['id']}"
    $ia_report = deployments::report_impact_analysis($impact_analysis)

    # Generate the detailed Impact Analysis report
    $ia_envs_report = $ia_report['results'].map |$ia_env_report| {
      $impacted_nodes_result = cd4pe_deployments::search_impacted_nodes($ia_env_report['IA_resultId'])
      $impacted_nodes = cd4pe_deployments::evaluate_result($impacted_nodes_result)
      deployments::report_impacted_nodes($ia_env_report, $impacted_nodes, $max_changes_per_node)
    }
  } else {
    $ia_envs_report = Tuple({})
    $ia_url = 'No Impact Analysis performed'
  }

  # Combine all reports into a single hash
  $report = deployments::combine_reports($stage_report, $scm_data, $ia_envs_report)

  ## Interact with ServiceNow
  # Process full pipeline structure to determine stage number of stage to promote to
  $pipeline_structure_result = cd4pe_deployments::get_pipeline($repo_type, $repo_name, $pipeline_id)
  $pipeline_structure = cd4pe_deployments::evaluate_result($pipeline_structure_result)
  unless $stage_to_promote_to {
    fail_plan('No stage specified for ServiceNow to promote approved changes to!', 'no_promote_stage_error')
  }
  $promote_stage = $pipeline_structure['stages'].filter |$item| { $item['stageName'] == $stage_to_promote_to }
  unless $promote_stage.length == 1 {
    fail_plan("Provided stage_to_promote_to '${stage_to_promote_to}' could not be found in pipeline. \
    Please ensure a valid stage name is specified!", 'stage_not_found_error')
  }
  $promote_stage_number = $promote_stage[0]['stageNum']
  # Trigger Change Request workflow in ServiceNow DevOps
  deployments::servicenow_change_request(
    $_snow_endpoint,
    $snow_username,
    $snow_password,
    $report,
    $ia_url,
    $promote_stage_number,
    $assignment_group,
    $connection_alias,
    $auto_create_ci
  )
}

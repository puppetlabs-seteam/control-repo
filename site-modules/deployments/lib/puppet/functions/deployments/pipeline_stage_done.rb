Puppet::Functions.create_function(:'deployments::pipeline_stage_done') do
  dispatch :pipeline_stage_done do
    required_param 'Tuple', :pipeline_stage
  end

  def jobstatus(job_status)
    case job_status
    when 'f' then 'FAILURE'
    when 's' then 'SUCCESS'
    when 'r' then 'RUNNING'
    when 'c' then 'CANCELED'
    when 'w' then 'QUEUED'
    else
      "Unknown status: #{job_status}"
    end
  end

  def pipeline_stage_done(pipeline_stage)
    bln_done = true
    pipeline_stage.each do |event|
      status =  case event['eventType']
                when 'VMJOB' then jobstatus(event['jobStatus'])
                when 'PEIMPACTANALYSIS' then event['state']
                when 'DEPLOYMENT'
                  if ['deployments::servicenow_integration', 'deployments::servicenow_devops_integration'].include?(event['deploymentPlanName'])
                    nil
                  else
                    event['deploymentState']
                  end
                end
      next unless status

      case status
      when 'RUNNING', 'QUEUED' then bln_done = false
      end
    end
    bln_done
  end
end

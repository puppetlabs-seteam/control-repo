# frozen_string_literal: true

Puppet::Functions.create_function(:'deployments::report_pipeline_stage') do
  dispatch :report_pipeline_stage do
    required_param 'Hash', :pipeline
    required_param 'String', :stage_number
    required_param 'String', :repo_name
  end

  def add2log(content)
    print(content + "\n")
    @report['log'] = if @report['log'] == ''
                       content
                     else
                       @report['log'] + "\n" + content
                     end
  end

  def jobstatus(job_status)
    case job_status
    when 'f' then 'FAILED'
    when 's' then 'SUCCESS'
    when 'r' then 'RUNNING'
    when 'a' then 'CANCELLED'
    when 'q' then 'QUEUED'
    else
      "Unknown status: #{job_status}"
    end
  end

  def report_pipeline_stage(pipeline, stage_number, repo_name)
    @report = {}
    @report['name'] = 'cd4pe-pipeline'
    @report['display_name'] = 'cd4pe-pipeline'
    @report['build'] = {}
    @report['build']['events'] = []
    @report['notes'] = []
    @report['artifacts'] = {}
    @report['log'] = ''
    @report['build']['full_url'] = ENV['WEB_UI_ENDPOINT'] + '/' + ENV['DEPLOYMENT_OWNER'] + '/repositories/' +
                                   repo_name + '?pipelineId=' + pipeline['pipelineId'] +
                                   '&eventId=' + pipeline['id'].to_s
    @report['build']['number'] = pipeline['id']
    @report['build']['owner'] = ENV['DEPLOYMENT_OWNER']
    @report['build']['pipeline'] = pipeline['pipelineId']
    @report['build']['phase'] = pipeline['stageNames'][stage_number]
    @report['build']['repo_name'] = repo_name
    @report['build']['repo_type'] = ENV['REPO_TYPE']
    @report['build']['queue_id'] = stage_number.to_i
    @report['build']['url'] = '/' + ENV['DEPLOYMENT_OWNER'] + '/repositories/' + repo_name +
                              '?pipelineId=' + pipeline['pipelineId'] + '&eventId=' + pipeline['id'].to_s
    @report['url'] = ENV['DEPLOYMENT_OWNER'] + '/repositories/' + repo_name +
                     '?pipelineId=' + pipeline['pipelineId']
    add2log('Pipeline #: ' + pipeline['id'].to_s)
    add2log(' Stage ' + stage_number.to_s + ': ' + pipeline['stageNames'][stage_number])
    bln_reporting_job_found = false
    pipeline['eventsByStage'][stage_number].each do |event|
      next unless event['eventType'] == 'DEPLOYMENT'
      next unless ['deployments::servicenow_integration', 'deployments::servicenow_devops_integration'].include?(event['deploymentPlanName'])

      bln_reporting_job_found = true
    end
    correction = bln_reporting_job_found ? 1 : 0
    add2log('  Number of events in stage: ' + (pipeline['eventsByStage'][stage_number].count - correction).to_s)
    bln_stage_success = true
    pipeline['eventsByStage'][stage_number].each do |event|
      eventinfo = {}
      if event['eventType'] == 'VMJOB'
        eventinfo['eventName'] = event['jobName']
        eventinfo['eventType'] = 'JOB'
        eventinfo['eventNumber'] = event['vmJobInstanceId']
        eventinfo['eventTime'] = event['eventTime']
        eventinfo['eventResult'] = jobstatus(event['jobStatus'])
        begin
          eventinfo['startTime'] = event.fetch('jobStartTime', event.fetch('jobEndTime'))
        rescue
          eventinfo['startTime'] = eventinfo['eventTime']
        end
        begin
          eventinfo['endTime'] = event.fetch('jobEndTime')
        rescue
          eventinfo['endTime'] = eventinfo['eventTime']
        end
        eventinfo['executionTime'] = (eventinfo['endTime'] - eventinfo['startTime']) / 1000
        add2log('   Event name: ' + eventinfo['eventName'])
        add2log('    Event status: ' + eventinfo['eventResult'])
        if eventinfo['eventResult'] != 'SUCCESS'
          bln_stage_success = false
        end
      elsif event['eventType'] == 'DEPLOYMENT'
        next if ['deployments::servicenow_integration', 'deployments::servicenow_devops_integration'].include?(event['deploymentPlanName'])

        eventinfo['eventName'] = event['deploymentPlanName'] + ' to ' + event['targetBranch']
        eventinfo['eventType'] = 'DEPLOY'
        eventinfo['eventNumber'] = event['deploymentId']
        eventinfo['eventTime'] = event['eventTime']
        eventinfo['eventResult'] = event['deploymentState']
        eventinfo['startTime'] = if event['deploymentStartTime'].zero?
                                   event['deploymentEndTime']
                                 else
                                   event['deploymentStartTime']
                                 end
        eventinfo['endTime'] = event['deploymentEndTime']
        eventinfo['executionTime'] = (eventinfo['endTime'] - eventinfo['startTime']) / 1000
        add2log('   Deployment name: ' + eventinfo['eventName'])
        add2log('    Deployment status: ' + eventinfo['eventResult'])
        if eventinfo['eventResult'] != 'DONE'
          bln_stage_success = false
        end
      elsif event['eventType'] == 'PEIMPACTANALYSIS'
        eventinfo['eventName'] = 'Impact Analysis'
        eventinfo['eventType'] = 'IA'
        eventinfo['eventNumber'] = event['impactAnalysisId']
        eventinfo['eventTime'] = event['eventTime']
        eventinfo['eventResult'] = event['state']
        eventinfo['startTime'] = event.fetch('startTime', event['endTime'])
        eventinfo['endTime'] = event['endTime']
        eventinfo['executionTime'] = (eventinfo['endTime'] - eventinfo['startTime']) / 1000
        add2log('   ' + eventinfo['eventName'])
        add2log('    Impact Analysis status: ' + eventinfo['eventResult'])
        if eventinfo['eventResult'] != 'DONE'
          bln_stage_success = false
        end
      else
        eventinfo['eventName'] = 'Unknown event'
        eventinfo['eventType'] = 'UNKNOWN'
        eventinfo['eventNumber'] = 0
        eventinfo['eventTime'] = 0
        eventinfo['eventResult'] = 'UNKNOWN'
        eventinfo['startTime'] = 0
        eventinfo['endTime'] = 0
        eventinfo['executionTime'] = 0
        add2log('   Event name: ' + eventinfo['eventName'])
        add2log('    Event status: ' + eventinfo['eventResult'])
      end
      @report['build']['events'].append(eventinfo)
    end

    first_event = @report['build']['events'][0]
    last_event = @report['build']['events'][-1]
    @report['build']['timestamp'] = first_event['eventTime']
    @report['build']['startTime'] = first_event['startTime']
    @report['build']['endTime'] = last_event['endTime']
    @report['build']['executionTime'] = (last_event['endTime'] - first_event['startTime']) / 1000
    if bln_stage_success == true
      add2log(' Stage succeeded')
      @report['build']['status'] = 'SUCCESS'
    else
      add2log(' Stage failed')
      @report['build']['status'] = 'FAILURE'
    end
    @report
  end
end

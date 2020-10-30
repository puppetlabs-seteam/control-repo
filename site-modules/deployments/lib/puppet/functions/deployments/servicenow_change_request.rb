require 'net/http'
require 'uri'
require 'json'

Puppet::Functions.create_function(:'deployments::servicenow_change_request') do
  dispatch :servicenow_change_request do
    required_param 'String',  :endpoint
    required_param 'String',  :username
    required_param 'String',  :password
    required_param 'Hash',    :report
    required_param 'String',  :ia_url
    required_param 'Integer', :promote_to_stage
    required_param 'String',  :assignment_group
    required_param 'String',  :connection_alias
    required_param 'Boolean', :auto_create_ci
  end

  def servicenow_change_request(endpoint, username, password, report, ia_url, promote_to_stage, assignment_group, connection_alias, auto_create_ci)
    # Map facts to populate when auto-creating CI's
    fact_map = {
      # PuppetDB fact => ServiceNow CI field
      'fqdn'                   => 'fqdn',
      'domain'                 => 'dns_domain',
      'serialnumber'           => 'serial_number',
      'operatingsystemrelease' => 'os_version',
      'physicalprocessorcount' => 'cpu_count',
      'processorcount'         => 'cpu_core_count',
      'processors.models.0'    => 'cpu_type',
      'memorysize_mb'          => 'ram',
      'is_virtual'             => 'virtual',
      'macaddress'             => 'mac_address',
    }

    # First, we need to create a new ServiceNow Change Request
    description = "Puppet%20-%20Automated%20Change%20Request%20for%20promoting%20commit%20#{report['scm']['commit'][0, 7]}%20('#{report['scm']['description']}')%20to%20stage%20#{promote_to_stage}"
    short_description = "Puppet%20Code%20-%20'#{report['scm']['description']}'%20to%20stage%20#{promote_to_stage}"
    request_uri = "#{endpoint}/api/sn_chg_rest/v1/change/normal?category=Puppet%20Code&short_description=#{short_description}&description=#{description}"
    request_response = make_request(request_uri, :post, username, password)
    raise Puppet::Error, "Received unexpected response from the ServiceNow endpoint: #{request_response.code} #{request_response.body}" unless request_response.is_a?(Net::HTTPSuccess)

    changereq = JSON.parse(request_response.body)

    # Next, we build a list of CIs that Impact Analysis flagged as impacted
    array_of_cis = []
    report['notes'].each do |ia|
      ia['IA_node_reports'].each_key do |node|
        ci_req_uri = "#{endpoint}/api/now/table/cmdb_ci?sysparm_query=name=#{node}"
        ci_req_response = make_request(ci_req_uri, :get, username, password)
        raise Puppet::Error, "Received unexpected response from the ServiceNow endpoint: #{ci_req_response.code} #{ci_req_response.body}" unless ci_req_response.is_a?(Net::HTTPOK)

        ci = JSON.parse(ci_req_response.body)
        if ci['result'].count.positive?
          array_of_cis.push(ci['result'][0]['sys_id'])
        elsif auto_create_ci
          # Build a PuppetDB query to get relevant facts
          fact_query_filter = []
          fact_map.each do |fact, _field|
            fact_name = fact.split('.')[0]
            fact_query_filter.push("name='#{fact_name}'")
          end
          query = "facts[name,value] { (#{fact_query_filter.join(' or ')}) and certname = '#{node}' }"
          # Instantiate Bolt's PDB client directly
          puppetdb_client = Puppet.lookup(:bolt_pdb_client)
          # Query PuppetDB
          fact_hash = puppetdb_client.make_query(query)
          # Convert the output to a more useable single hash (PDB returns an array of hashes)
          facts = fact_hash.map { |item| [item['name'], item['value']] }.to_h
          # Build the payload for ServiceNow, set the mandatory 'name' field to the node's certname
          fact_payload = { 'name' => node }
          # Add facts based on the fact_map at the start of the function
          fact_map.each do |fact, ci_field|
            if fact.split('.').count > 1
              # Dot-walk structured facts
              tmp_fact = facts
              fact.split('.').each do |sub_fact|
                tmp_fact = ((sub_fact.to_i.to_s == sub_fact) ? tmp_fact[sub_fact.to_i] : tmp_fact[sub_fact])
              end
              fact_payload[ci_field] = tmp_fact.to_s
            else
              # Directly use non-structured facts
              fact_payload[ci_field] = facts[fact].to_s
            end
          end
          # Make the API call
          new_ci_uri = "#{endpoint}/api/now/table/cmdb_ci_server"
          new_ci_response = make_request(new_ci_uri, :post, username, password, fact_payload)
          raise Puppet::Error, "Received unexpected response from the ServiceNow endpoint: #{new_ci_response.code} #{new_ci_response.body}" unless new_ci_response.is_a?(Net::HTTPSuccess)

          # Grab the response to push the sys_id to the array_of_cis
          new_ci = JSON.parse(new_ci_response.body)
          array_of_cis.push(new_ci['result']['sys_id'])
        else
          Puppet.debug("servicenow_change_request: could not find CI #{node} in ServiceNow, skipping setting this as an affected CI...")
        end
      end
    end

    # And then associate those CIs into the ticket
    if array_of_cis.count.positive?
      assoc_ci_uri = "#{endpoint}/api/sn_chg_rest/v1/change/#{changereq['result']['sys_id']['value']}/ci"
      payload = { 'cmdb_ci_sys_ids' => array_of_cis.join(','), 'association_type' => 'affected' }
      # This next request will fail on ServiceNow versions older than New York, if so we fallback to the old task_ci mechanism
      assoc_ci_response = make_request(assoc_ci_uri, :post, username, password, payload)
      if assoc_ci_response.is_a?(Net::HTTPSuccess)
        # This is New York or newer, continue to process response
        assoc_ci_worker = JSON.parse(assoc_ci_response.body)
        assoc_ci_worker_uri = "#{endpoint}/api/sn_chg_rest/change/worker/#{assoc_ci_worker['result']['worker']['sysId']}"
        while assoc_ci_worker['result']['state']['value'] < 3
          sleep 3
          assoc_ci_response = make_request(assoc_ci_worker_uri, :get, username, password)
          assoc_ci_worker = JSON.parse(assoc_ci_response.body)
        end
        raise Puppet::Error, "Failed to associate CI's, got these error(s): #{assoc_ci_worker['result']['messages']['errorMessages']}" unless assoc_ci_worker['result']['state']['value'] == 3
      elsif assoc_ci_response.code == '400' && JSON.parse(assoc_ci_response.body)['error']['message'].start_with?('Requested URI does not represent any resource')
        # This is a pre-New York version (e.g. Madrid), use the task_ci table instead
        array_of_cis.each do |ci|
          task_ci_uri = "#{endpoint}/api/now/table/task_ci"
          task_ci_payload = { 'ci_item' => ci, 'task' => changereq['result']['sys_id']['value'] }
          task_ci_response = make_request(task_ci_uri, :post, username, password, task_ci_payload)
          raise Puppet::Error, "Received unexpected response from the ServiceNow endpoint: #{task_ci_response.code} #{task_ci_response.body}" unless task_ci_response.is_a?(Net::HTTPSuccess)
        end
      else
        # A real error occurred, raise the error
        raise Puppet::Error, "Received unexpected response from the ServiceNow endpoint: #{assoc_ci_response.code} #{assoc_ci_response.body}"
      end
    end

    # Finally, we populate the remaining information into the change request, and activate it
    # Build close notes, used for automated promotion later
    closenotes = {}
    closenotes['commitSHA']       = report['scm']['commit']
    closenotes['commitMsg']       = report['scm']['description'].strip
    closenotes['eventId']         = report['build']['number']
    closenotes['pipelineId']      = report['build']['pipeline']
    closenotes['workspace']       = report['build']['owner']
    closenotes['repoName']        = report['build']['repo_name']
    closenotes['repoType']        = report['build']['repo_type']
    closenotes['promoteToStage']  = promote_to_stage
    closenotes['scm_branch']      = report['scm']['branch']
    closenotes['connection']      = connection_alias
    bln_ia_safe_verdict = true
    report['notes'].each do |ia|
      unless ia['IA_verdict'] == 'safe'
        bln_ia_safe_verdict = false
      end
    end
    closenotes['impact_analysis'] = bln_ia_safe_verdict ? 'safe' : 'unsafe'

    # Get sys_id of given assignment_group
    assignment_group_url = "#{endpoint}/api/now/table/sys_user_group?sysparm_query=name=#{assignment_group}"
    assignment_group_response = make_request(assignment_group_url, :get, username, password)
    raise Puppet::Error, "Received unexpected response from the ServiceNow endpoint: #{assignment_group_response.code} #{assignment_group_response.body}" unless assignment_group_response.is_a?(Net::HTTPOK) # rubocop:disable Metrics/LineLength

    arr_assignment_groups = JSON.parse(assignment_group_response.body)['result']
    raise Puppet::Error, "No Assignment Group named '#{assignment_group}' was found in ServiceNow!" unless arr_assignment_groups.count.positive?

    assignment_group_sys_id = arr_assignment_groups[0]['sys_id']

    # Update Change Request with additional info, and start the approval process
    change_req_url = "#{endpoint}/api/sn_chg_rest/v1/change/normal/#{changereq['result']['sys_id']['value']}?state=assess"
    payload = {
      'risk_impact_analysis' => ia_url + "\n" + report['log'],
      'assignment_group' => assignment_group_sys_id,
      'close_notes' => closenotes.to_json,
    }
    change_req_url_res = make_request(change_req_url, :patch, username, password, payload)
    raise Puppet::Error, "Received unexpected response from the ServiceNow endpoint: #{change_req_url_res.code} #{change_req_url_res.body}" unless change_req_url_res.is_a?(Net::HTTPSuccess)
  end

  def make_request(endpoint, type, username, password, payload = nil)
    uri = URI.parse(endpoint)

    connection = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      connection.use_ssl = true
    end

    connection.read_timeout = 60

    max_attempts = 3
    attempts = 0

    while attempts < max_attempts
      attempts += 1
      begin
        Puppet.debug("servicenow_change_request: performing #{type} request to #{endpoint}")
        case type
        when :delete
          request = Net::HTTP::Delete.new(uri.request_uri)
        when :get
          request = Net::HTTP::Get.new(uri.request_uri)
        when :post
          request = Net::HTTP::Post.new(uri.request_uri)
          request.body = payload.to_json unless payload.nil?
        when :patch
          request = Net::HTTP::Patch.new(uri.request_uri)
          request.body = payload.to_json unless payload.nil?
        else
          raise Puppet::Error, "servicenow_change_request#make_request called with invalid request type #{type}"
        end
        request.basic_auth(username, password)
        request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        response = connection.request(request)
      rescue SocketError => e
        raise Puppet::Error, "Could not connect to the ServiceNow endpoint at #{uri.host}: #{e.inspect}", e.backtrace
      end

      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        return response
      when Net::HTTPInternalServerError
        if attempts < max_attempts # rubocop:disable Style/GuardClause
          Puppet.debug("Received #{response} error from #{uri.host}, attempting to retry. (Attempt #{attempts} of #{max_attempts})")
          Kernel.sleep(3)
        else
          raise Puppet::Error, "Received #{attempts} server error responses from the ServiceNow endpoint at #{uri.host}: #{response.code} #{response.body}"
        end
      else
        return response
      end
    end
  end
end

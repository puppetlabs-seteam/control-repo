plan deployments::show_system_info (
  Enum['Linux', 'windows'] $operatingsystem,
) {
  # Assumption: There are target nodes managed by Puppet, that have a fact called 'kernel' installed on them. 
  # 
  # more info on how to write PuppetDB query strings is here: https://www.puppet.com/docs/puppetdb/7/api/query/tutorial-pql.html

  # query puppetdb to find the nodes that have values 'kernel = Linux' or 'kernel = windows'  
  $query = [from, nodes, ['=', [fact, kernel], $operatingsystem]] # note that the fact name 'kernel' is used in the query string
  $selected_nodes = puppetdb_query($query).map() |$target| { $target[certname] }

  # call the metadata json file name. the metadata file will call the appropriate Linux or Win script.
  run_task('deployments::show_system_info', $selected_nodes)
}

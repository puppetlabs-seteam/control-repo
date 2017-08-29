class profile::app::jenkins::master(
  $listen_port = '8080',
  $version = '2.62',
){

  if $::kernel != 'Linux' {
    fail('Unsupported OS!')
  }

  class {'::profile::app::java':
    distribution => 'jdk',
  }

  class {'::jenkins':
    configure_firewall => true,
    install_java       => false,
    require            => Class['profile::app::java'],
    version            => $version,
    lts                => false,
    service_provider   => 'redhat',
  }

  jenkins::plugin { 'git': }
  jenkins::plugin { 'git-client': }
  jenkins::plugin { 'jackson2-api': }
  jenkins::plugin { 'cloudbees-folder': }
  jenkins::plugin { 'swarm': }
  jenkins::plugin { 'ansicolor': }
  jenkins::plugin { 'ws-cleanup': }
  jenkins::plugin { 'puppet-enterprise-pipeline': }
  jenkins::plugin { 'pipeline-build-step': }
  jenkins::plugin { 'pipeline-milestone-step': }
  jenkins::plugin { 'resource-disposer': }
  jenkins::plugin { 'structs': }
  jenkins::plugin { 'script-security': }
  jenkins::plugin { 'metrics': }
  jenkins::plugin { 'variant': }
  jenkins::plugin { 'junit': }
  jenkins::plugin { 'mailer': }
  jenkins::plugin { 'workflow-api': }
  jenkins::plugin { 'branch-api': }
  jenkins::plugin { 'workflow-job': }
  jenkins::plugin { 'workflow-multibranch': }
  jenkins::plugin { 'scm-api': }
  jenkins::plugin { 'display-url-api': }
  jenkins::plugin { 'workflow-basic-steps': }
  jenkins::plugin { 'workflow-step-api': }
  jenkins::plugin { 'workflow-support': }
  jenkins::plugin { 'workflow-cps': }
  jenkins::plugin { 'workflow-durable-task-step': }
  jenkins::plugin { 'workflow-scm-step': }
  jenkins::plugin { 'blueocean-pipeline-scm-api': }
  jenkins::plugin { 'blueocean-autofavorite': }
  jenkins::plugin { 'blueocean-bitbucket-pipeline': }
  jenkins::plugin { 'blueocean-commons': }
  jenkins::plugin { 'blueocean-config': }
  jenkins::plugin { 'blueocean-dashboard': }
  jenkins::plugin { 'blueocean-display-url': }
  jenkins::plugin { 'blueocean-events': }
  jenkins::plugin { 'blueocean-git-pipeline': }
  jenkins::plugin { 'blueocean-github-pipeline': }
  jenkins::plugin { 'blueocean-i18n': }
  jenkins::plugin { 'blueocean-jwt': }
  jenkins::plugin { 'blueocean-personalization': }
  jenkins::plugin { 'blueocean-pipeline-api-impl': }
  jenkins::plugin { 'blueocean-pipeline-editor': }
  jenkins::plugin { 'blueocean-rest': }
  jenkins::plugin { 'blueocean-rest-impl': }
  jenkins::plugin { 'blueocean-web': }
  jenkins::plugin { 'blueocean': }
  jenkins::plugin { 'ace-editor': }
  jenkins::plugin { 'jquery-detached': }
  jenkins::plugin { 'durable-task': }
  jenkins::plugin { 'jira': }
  jenkins::plugin { 'ssh-credentials': }
  jenkins::plugin { 'favorite': version => '2.3.0' }
  jenkins::plugin { 'plain-credentials': }
  jenkins::plugin { 'pubsub-light': }
  jenkins::plugin { 'token-macro': }
  jenkins::plugin { 'workflow-aggregator': }
  jenkins::plugin { 'pipeline-input-step': }
  jenkins::plugin { 'workflow-cps-global-lib': }
  jenkins::plugin { 'pipeline-stage-view': }
  jenkins::plugin { 'pipeline-model-definition': }
  jenkins::plugin { 'pipeline-stage-step': }
  jenkins::plugin { 'pipeline-rest-api': }
  jenkins::plugin { 'handlebars': }
  jenkins::plugin { 'momentjs': }
  jenkins::plugin { 'git-server': }
  jenkins::plugin { 'credentials-binding': }
  jenkins::plugin { 'docker-workflow': }
  jenkins::plugin { 'pipeline-model-api': }
  jenkins::plugin { 'pipeline-model-declarative-agent': }
  jenkins::plugin { 'pipeline-model-extensions': }
  jenkins::plugin { 'pipeline-stage-tags-metadata': }
  jenkins::plugin { 'pipeline-graph-analysis': }
  jenkins::plugin { 'docker-commons': }
  jenkins::plugin { 'icon-shim': }
  jenkins::plugin { 'authentication-tokens': }
  jenkins::plugin { 'github-branch-source': }
  jenkins::plugin { 'htmlpublisher': }
  jenkins::plugin { 'github': }
  jenkins::plugin { 'github-api': }
  jenkins::plugin { 'sse-gateway': }
  jenkins::plugin { 'cloudbees-bitbucket-branch-source': }
  jenkins::plugin { 'mercurial': }

}

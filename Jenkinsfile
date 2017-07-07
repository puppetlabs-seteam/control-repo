#!groovy
node('tse-control-repo') {
  sshagent (credentials: ['jenkins-seteam-ssh']) {
    checkout scm

    stage('Lint Control Repo'){
      withEnv(['PATH+EXTRA=/usr/local/bin']) {
        ansiColor('xterm') {
          sh(script: '''
            source ~/.bash_profile
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle install
            bundle exec rake lint
          ''')
        }
      }
    }

    stage('Syntax Check Control Repo'){
      withEnv(['PATH+EXTRA=/usr/local/bin']) {
        ansiColor('xterm') {
          sh(script: '''
            source ~/.bash_profile
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle install
            bundle exec rake syntax --verbose
          ''')
        }
      }
    }

    stage('Validate Puppetfile in Control Repo'){
      withEnv(['PATH+EXTRA=/usr/local/bin']) {
        ansiColor('xterm') {
          sh(script: '''
            source ~/.bash_profile
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle install
            bundle exec rake r10k:syntax
          ''')
        }
      }
    }
  }
}

stage('Run Spec Tests') {
  parallel(
    'linux::profile::spec': {
      runSpecTests('linux','profile')
    },
    'windows::profile::spec': {
      runSpecTests('windows','profile')
    },
    'linux::role::spec': {
      runSpecTests('linux','role')
    },
    'windows::role::spec': {
      runSpecTests('windows','role')
    }
  )
}


// functions
def linux(){
  withEnv(['PATH+EXTRA=/usr/local/bin']) {
    ansiColor('xterm') {
      sh(script: '''
        sleep $(( ( RANDOM % 10 )  + 1 ))
        source ~/.bash_profile
        rbenv global 2.3.1
        bundle install
        bundle exec rake spec
      ''')
    }
  }
}

def windows(){
  withEnv(['MODULE_WORKING_DIR=C:/tmp']) {
    ansiColor('xterm') {
      sh(script: '''
        bundle install
        bundle exec rake spec
      ''')
    }
  }
}

def runSpecTests(def platform,def target){
  node('tse-slave-' + platform) {
    sshagent (credentials: ['jenkins-seteam-ssh']) {
      checkout scm
      dir("site/$target") {
        "$platform"()
      }
    }
  }
}

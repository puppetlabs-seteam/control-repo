#!groovy
node('tse-control-repo') {
  sshagent (credentials: ['jenkins-seteam-ssh']) {
    withEnv(['PATH+EXTRA=/usr/local/bin']) {
      checkout scm

      stage('Setup'){
        ansiColor('xterm') {
          sh(script: '''
            export PATH=$PATH:$HOME/.rbenv/bin
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            rm -f Gemfile.lock
            bundle install
          ''')
        }
      }

      stage('Lint Control Repo'){
        ansiColor('xterm') {
          sh(script: '''
            export PATH=$PATH:$HOME/.rbenv/bin
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle exec rake lint
          ''')
        }
      }

      stage('Syntax Check Control Repo'){
        ansiColor('xterm') {
          sh(script: '''
            export PATH=$PATH:$HOME/.rbenv/bin
            rbenv global 2.3.1
            eval "$(rbenv init -)"
            bundle exec rake syntax --verbose
          ''')
        }
      }

      stage('Validate Puppetfile in Control Repo'){
        ansiColor('xterm') {
          sh(script: '''
            export PATH=$PATH:$HOME/.rbenv/bin
            rbenv global 2.3.1
            eval "$(rbenv init -)"
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
        export PATH=$PATH:$HOME/.rbenv/bin:$HOME/.rbenv/shims
        echo $PATH
        sleep $(( ( RANDOM % 10 )  + 1 ))
        rbenv global 2.3.1
        gem install bundle
        rm -f Gemfile.lock
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
        rm -f Gemfile.lock
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

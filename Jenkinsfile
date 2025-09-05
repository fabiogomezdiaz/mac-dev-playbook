// Jenkinsfile (Docker agent with Ansible preinstalled)
pipeline {
  agent {
    docker {
      image 'geerlingguy/docker-ubuntu2404-ansible:latest'
      args '-u root:root'     // avoid perms issues writing temp files / SSH keys
      reuseNode true
    }
  }
  options { ansiColor('xterm'); timestamps() }
  environment {
    ANSIBLE_CONFIG = "${WORKSPACE}/ansible.cfg"
    ANSIBLE_STDOUT_CALLBACK = 'yaml'
    ANSIBLE_FORCE_COLOR = 'true'
  }
  parameters {
    string(name: 'TAGS', defaultValue: '', description: 'Optional Ansible tags (comma-separated)')
    booleanParam(name: 'CHECK_MODE', defaultValue: false, description: 'Run with --check (dry run)')
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    // stage('Ensure ssh client in container') {
    //   steps {
    //     sh '''
    //       set -euxo pipefail
    //       command -v ssh >/dev/null 2>&1 || (apt-get update && apt-get install -y --no-install-recommends openssh-client)
    //     '''
    //   }
    // }

    stage('Galaxy deps') {
      steps {
        sh '''
          set -eux pipefail
          test -f requirements.yml && ansible-galaxy install -r requirements.yml --force || echo "No requirements.yml; skipping."
        '''
      }
    }

    stage('Run mac-dev-playbook') {
      steps {
        ansiblePlaybook(
          playbook: 'main.yml',
          inventory: 'inventory',
          colorized: true,
          checkMode: params.CHECK_MODE,
          // Jenkins SSH private key for your macOS user:
          credentialsId: 'mac-ssh',
          disableHostKeyChecking: true,
          extras: '--diff',
          extraVars: [ ansible_python_interpreter: '/usr/bin/python3' ],
          tags: params.TAGS
        )
      }
    }
  }
  post {
    success { echo '✅ mac-dev-playbook completed.' }
    failure { echo '❌ mac-dev-playbook failed — check the console log.' }
  }
}

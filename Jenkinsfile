// Jenkinsfile (Docker agent with Ansible preinstalled; no sshagent)
pipeline {
  agent {
    docker {
      image 'geerlingguy/docker-ubuntu2404-ansible:latest'
      args '-u root:root'
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

    stage('Galaxy deps') {
      steps {
        sh '''
          set -eu pipefail
          test -f requirements.yml && ansible-galaxy install -r requirements.yml --force || echo "No requirements.yml; skipping."
        '''
      }
    }

    stage('Run mac-dev-playbook') {
      steps {
        withCredentials([
          sshUserPrivateKey(credentialsId: 'mac-ssh', keyFileVariable: 'SSH_KEY_FILE', usernameVariable: 'SSH_USER'),
          string(credentialsId: 'mac-become-password', variable: 'BECOME_PASSWORD')
        ]) {
          sh '''
            set -eu pipefail
            # Create temporary password file
            BECOME_PASS_FILE=$(mktemp)
            echo "${BECOME_PASSWORD}" > "${BECOME_PASS_FILE}"
            chmod 600 "${BECOME_PASS_FILE}"

            # Run ansible-playbook
            ansible-playbook main.yml \
              --inventory inventory \
              --private-key "${SSH_KEY_FILE}" \
              --user "${SSH_USER}" \
              --become-password-file "${BECOME_PASS_FILE}" \
              --become \
              --become-user root \
              --diff \
              --extra-vars "ansible_python_interpreter=/usr/bin/python3"

            # Clean up password file
            rm -f "${BECOME_PASS_FILE}"
          '''
        }
      }
    }
  }
  post {
    success { echo '✅ mac-dev-playbook completed.' }
    failure { echo '❌ mac-dev-playbook failed — check the console log.' }
  }
}

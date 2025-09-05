// Jenkinsfile (Docker agent with Ansible preinstalled; force-install ssh client)
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
    // Belt & suspenders: make sure common bins are on PATH
    PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"
  }
  parameters {
    string(name: 'TAGS', defaultValue: '', description: 'Optional Ansible tags (comma-separated)')
    booleanParam(name: 'CHECK_MODE', defaultValue: false, description: 'Run with --check (dry run)')
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Install SSH client') {
      steps {
        sh '''
          set -eu pipefail
          export DEBIAN_FRONTEND=noninteractive
          apt-get update
          apt-get install -y --no-install-recommends openssh-client
          which ssh
          ssh -V || true
        '''
      }
    }

    stage('Galaxy deps') {
      steps {
        sh '''
          set -eu pipefail
          if [ -f requirements.yml ]; then
            ansible-galaxy install -r requirements.yml --force
          else
            echo "No requirements.yml; skipping."
          fi
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

            # Create a temporary become password file (keeps secret out of argv/env)
            BECOME_PASS_FILE="$(mktemp)"
            printf '%s' "${BECOME_PASSWORD}" > "${BECOME_PASS_FILE}"
            chmod 600 "${BECOME_PASS_FILE}"

            # Optional preflight: quick connectivity check (comment out if noisy)
            # ansible -i inventory all -m ping -u "${SSH_USER}" --private-key "${SSH_KEY_FILE}" -vv || true

            # Run playbook
            ansible-playbook main.yml \
              --inventory inventory \
              --private-key "${SSH_KEY_FILE}" \
              --user "${SSH_USER}" \
              --become --become-user root \
              --become-password-file "${BECOME_PASS_FILE}" \
              --diff \
              --extra-vars "ansible_python_interpreter=/usr/bin/python3" \
              ${CHECK_MODE:+--check} \
              ${TAGS:+--tags "${TAGS}"}

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

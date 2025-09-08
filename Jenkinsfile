// Jenkinsfile (Docker agent with Ansible preinstalled; force-install ssh client)
pipeline {
  agent {
    docker {
      image 'geerlingguy/docker-ubuntu2404-ansible:latest'
      args """
        -u root:root \
        --dns 192.168.3.1 \
        --dns 192.168.2.2 \
        --dns-search fabiongo.com
      """
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
    string(name: 'SKIP_TAGS', defaultValue: 'osx,sublime-text', description: 'Ansible tags to skip (ignored if TAGS is set)')
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
          file(credentialsId: 'mac-dev-playbook-config', variable: 'CONFIG_FILE'),
          sshUserPrivateKey(credentialsId: 'mac-ssh', keyFileVariable: 'SSH_KEY_FILE', usernameVariable: 'SSH_USER'),
          string(credentialsId: 'mac-become-password', variable: 'BECOME_PASSWORD')
        ]) {
          sh '''
            set -eu pipefail

            # Copy config file from Jenkins credentials to repo root
            cp "${CONFIG_FILE}" ./config.yml
            echo "Config file copied to repo root"

            # Start SSH agent and add the private key
            eval "$(ssh-agent -s)"
            ssh-add "${SSH_KEY_FILE}"

            # Create a temporary become password file (keeps secret out of argv/env)
            BECOME_PASS_FILE="$(mktemp)"
            printf '%s' "${BECOME_PASSWORD}" > "${BECOME_PASS_FILE}"
            chmod 600 "${BECOME_PASS_FILE}"

            # Preflight: Ansible connectivity check
            echo "Testing Ansible connectivity..."
            ansible all -m ping \
              --inventory inventory \
              --become-password-file "${BECOME_PASS_FILE}" \
              --ssh-common-args "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
              --diff \
              --extra-vars "ansible_python_interpreter=/usr/bin/python3"
            echo "Ansible connectivity check passed."

            # Run playbook (no need for --private-key since it's in SSH agent)
            # Build tag arguments conditionally
            TAG_ARGS=""
            if [ -n "${TAGS}" ]; then
              TAG_ARGS="--tags ${TAGS}"
            else
              TAG_ARGS="--skip-tags ${SKIP_TAGS}"
            fi

            ansible-playbook main.yml \
              --inventory inventory \
              --become-password-file "${BECOME_PASS_FILE}" \
              --diff \
              --extra-vars "ansible_python_interpreter=/usr/bin/python3" \
              --ssh-common-args "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
              ${TAG_ARGS}

            # Clean up
            ssh-agent -k || true
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

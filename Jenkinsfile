// Jenkinsfile
pipeline {
  agent any
  options {
    ansiColor('xterm')
    timestamps()
  }
  environment {
    // Use the repo's Ansible config (if present)
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
        // Requires Ansible on PATH (configure as a Jenkins tool or install on the agent)
        sh 'ansible-galaxy install -r requirements.yml'
      }
    }

    stage('Run mac-dev-playbook') {
      matrix {
        axes {
          // These MUST match hostnames you define in your inventory file
          axis { name 'TARGET'; values 'macbook_pro', 'macmini' }
        }
        stages {
          stage('Ansible') {
            steps {
              ansiblePlaybook(
                playbook: 'main.yml',      // repo entrypoint
                inventory: 'inventory',    // repo inventory
                limit: "${TARGET}",        // run per host
                colorized: true,
                checkMode: params.CHECK_MODE,
                // Jenkins credentials: SSH private key for the Mac user
                credentialsId: 'mac-ssh',
                // Name of the Ansible "installation" configured in Jenkins tools
                installation: 'Ansible',
                // Avoid interactive host key prompts on first connect
                disableHostKeyChecking: true,
                // Nice to have: see changes in the log
                extras: '--diff',
                // Helpful on macOS where Python 3 is /usr/bin/python3
                extraVars: [ ansible_python_interpreter: '/usr/bin/python3' ],
                // Optional: run a subset of tasks (e.g., "homebrew,mas")
                tags: params.TAGS
                // If you use Ansible Vault for MAS creds, you can also set:
                // vaultCredentialsId: 'ansible-vault-pass'
              )
            }
          }
        }
      }
    }
  }
  post {
    success { echo '✅ mac-dev-playbook completed.' }
    failure { echo '❌ mac-dev-playbook failed — check the console log.' }
  }
}

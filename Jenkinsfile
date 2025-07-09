pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-west-1'
        KEY_NAME = 'DOCKER'
        PRIVATE_KEY = credentials('ubuntu04')  // Ensure this matches Jenkins Credentials ID
    }

    stages {

        stage('Clone Repo') {
            steps {
                 git branch: 'main', url: 'https://github.com/Khanduri004/terraform-ansible-aws-project.git'
            }
        }

        stage('Terraform Init & Apply') {
          steps {
            withCredentials([
             string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
             string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
             ])   {
             dir('terraform') {
              sh '''
              export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
              export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
              terraform init
              terraform apply -auto-approve -var="key_name=${KEY_NAME}"
            '''
          }
        }
      }
    }

        stage('Configure Inventory') {
            steps {
                script {
                    def publicIp = sh(
                        returnStdout: true, 
                        script: "terraform -chdir=terraform output -raw public_ip"
                    ).trim()

                    writeFile file: 'ansible/inventory.ini', 
                              text: "[appservers]\n${publicIp} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa"
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }

        stage('Build & Run Docker Container') {
            steps {
                sshagent(['your-ssh-credential-id']) {  // replace with your real Jenkins SSH credential ID
                    script {
                        def publicIp = sh(
                            returnStdout: true, 
                            script: "terraform -chdir=terraform output -raw public_ip"
                        ).trim()

                        sh """
                            ssh -o StrictHostKeyChecking=no ec2-user@${publicIp} 'docker pull yourdockerhubusername/flask-app:latest || true'
                            ssh -o StrictHostKeyChecking=no ec2-user@${publicIp} 'docker stop flask-app || true'
                            ssh -o StrictHostKeyChecking=no ec2-user@${publicIp} 'docker rm flask-app || true'
                            ssh -o StrictHostKeyChecking=no ec2-user@${publicIp} 'docker run -d -p 5000:5000 --name flask-app yourdockerhubusername/flask-app:latest'
                        """
                    }
                }
            }
        }

    }
}

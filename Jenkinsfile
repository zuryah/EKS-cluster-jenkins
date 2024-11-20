pipeline {
    agent any

    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform action')
        string(name: 'USERNAME_NAME', defaultValue: 'surya', description: 'Who is running the pipeline')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-west-2c'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    // Use withCredentials for git_PAT
                    withCredentials([string(credentialsId: 'git_PAT', variable: 'GIT_PAT')]) {
                        sh """
                        git clone https://$GIT_PAT@github.com/zuryah/EKS-cluster-jenkins.git"
                        """
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform with AWS credentials
                    dir('EKS-cluster-jenkins') {
                        withCredentials([
                            string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    // Perform the selected Terraform action
                    if (params.TERRAFORM_ACTION == 'apply') {
                        dir('EKS-cluster-jenkins') {
                            sh 'terraform apply -auto-approve'
                        }
                    } else if (params.TERRAFORM_ACTION == 'destroy') {
                        dir('EKS-cluster-jenkins') {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else if (params.TERRAFORM_ACTION == 'plan') {
                        dir('EKS-cluster-jenkins') {
                            sh 'terraform plan'
                        }
                    } else {
                        error "Invalid Terraform action selected: ${params.TERRAFORM_ACTION}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after pipeline execution
            cleanWs()
        }
    }

    options {
        buildDiscarder(logrotator(numToKeepStr: '10'))
    }
}

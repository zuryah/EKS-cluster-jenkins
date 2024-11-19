pipeline {
    agent any 

    parameters {
        choice (name:'TERRAFORM_ACTION', choices:['plan','apply','destroy'], description: 'select terraform action')
        string (name: 'USERNAME_NAME' defaultValue: 'surya', description: 'who is running the pipe')
    }
    environment
    {
        AWS_ACCESS_KEY_ID       = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY   = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION      =  'us-west-2c'
        
    }

    stages {
        stage ('checkout scm')
           steps {
            script{
                withCredentials([string(credentialsId: 'root(red)', variable: 'ROOT(RED)')]) {
                    sh "git clone https://$ROOT(RED)@github.com/zuryah/EKS-cluster-jenkins.git"
            }
            
           }
    
           }
        
            stage('Terraform init') 
                steps {
                //initialize terraform
                //use withCredentials for AWS credentials
                dir('EKS-cluster-jenkins') {
                    withCredentials([string(credentialsId: 'aws-access-key-id, variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform init'             
                    }
                }
            }
            stage('Terraform action')
                steps {
                    script {
                         //Perform selected terraform action
                         if (params.TERRAFORM_ACTION == 'apply') {
                            dir('EKS-cluster-jenkins') {
                                sh 'terraform apply -auto-approve'
                            }
                        } else if (params.TERRAFORM_ACTION == 'destroy') {
                            dir('EKS-cluster-jenkins') {
                                sh 'terraform destroy -auto-approvde'
                            }
                        } else if(params.TERRAFORM_ACTION =='plan') {
                            dir('EKS-cluster-jenkins') {
                                sh 'terraform plan'
                            }
                        } else {
                            error "Invalid Terraform action selected: $(params.TERRAFORM_ACTION)"
                        }
                    }
                }
                post {
                    always {
                       //clean up workspace after pipeline execution
                       cleanWS()
                    }
                }
                options {
                    buildDiscarder(logrotator(numToKeepStr: '10'))
                }
        }
    }

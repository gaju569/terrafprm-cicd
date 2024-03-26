pipeline {
    agent any
    
    environment {
        TF_VERSION = "1.1.0" // Specify the Terraform version you want to use
        TF_VAR_region = "us-east-1" // Specify the AWS region
        TF_VAR_instance_type = "t2.micro" // Specify the EC2 instance type
        TF_VAR_ami = "ami-0c101f26f147fa7fd" // Specify the AMI ID
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo/terraform.git' // Specify your Terraform repository URL
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}

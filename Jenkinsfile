pipeline {
    agent any
      environment {
        VC = credentials('VCACC')
        TF_VAR_VSPHERE_USER = "${VC_USR}"
        TF_VAR_VSPHERE_PASS = "${VC_PSW}"
        JD = credentials('JDACC')
        TF_VAR_DOMAIN_USER = "${JD_USR}"
        TF_VAR_DOMAIN_PASS = "${JD_PWS}"
  }

    stages {
                stage('Echo') {
            steps {
                echo "${VC_USR}"
                echo "${JD_USR}"
            }
        }
        stage('SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/0psdev/Demo02.git'
            }
        }
        stage('Initial') {
            steps {
                bat 'terraform init'
            }
        }
        stage('Planning') {
            steps {
                bat 'terraform plan'
            }
        }
        stage('Deploy') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }        
    }
}
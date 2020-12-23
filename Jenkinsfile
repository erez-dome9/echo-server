pipeline {
  environment {
    registry = "erezweinstein/my-flask-server"
    registryCredential = 'dockerhub'
    dockerImage = ''
    VERSION = 'latest'
    PROJECT = 'tap_sample'
    IMAGE = 'tap_sample:latest'
    ECRURL = 'http://549246567444.dkr.ecr.us-east-1.amazonaws.com/echo-server'
    ECRCRED = 'ecr:us-east-1:echo-server'
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
            git branch: 'app-and-dockerfile',
                url: 'https://github.com/erez-dome9/echo-server.git'
            sh "ls -lat"
        }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
            docker.withRegistry('', registryCredential ) {
            dockerImage.push()
            dockerImage.push('latest')
          }
        }
      }
    }
//     stage('Remove Unused docker image') {
//       steps{
//         sh "docker rmi $registry:$BUILD_NUMBER"
//       }
//     }
  }
}
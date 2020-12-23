pipeline {
  environment {
    registry = "549246567444.dkr.ecr.us-east-1.amazonaws.com/echo-server"
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
            docker.withRegistry(ECRURL, ECRCRED) {
            dockerImage.push()
            dockerImage.push('latest')
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
    stage('Deploy to ECS') {
      steps{
        sh
        "
            SERVICE_NAME="flask-signup-service"
            IMAGE_VERSION="v_"${BUILD_NUMBER}
            TASK_FAMILY="flask-signup"

            # Create a new task definition for this build
            sed -e "s;%IMAGE_PLACEHOLDER%;${registry}:latest;g" echo-server-task-definition-template.json > echo-server-task-definition.json
            aws ecs register-task-definition --family echo-server --cli-input-json file://echo-server-task-definition.json

            # Update the service with the new task definition and desired count
            TASK_REVISION=`aws ecs describe-task-definition --task-definition flask-signup | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
            DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} | egrep "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
            if [ ${DESIRED_COUNT} = "0" ]; then
                DESIRED_COUNT="1"
            fi
        "
      }
    }
  }
}
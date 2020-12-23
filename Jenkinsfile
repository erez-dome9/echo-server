pipeline {
  environment {
    region = 'us-east-1'
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
            CLUSTER_NAME="echo-server"
            SERVICE_NAME="echo-server-service"
            TASK_FAMILY="flask-signup"

            # Create a new task definition for this build
            sed -e "s;%IMAGE_PLACEHOLDER%;${registry}:latest;g" echo-server-task-definition-template.json > echo-server-task-definition.json
            aws ecs register-task-definition --family echo-server --cli-input-json file://echo-server-task-definition.json --region ${region}

            # Update the service with the new task definition and desired count
            TASK_REVISION=`aws ecs describe-task-definition --task-definition echo-server | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
            DESIRED_COUNT=`aws ecs describe-services --cluster ${CLUSTER_NAME} --services ${SERVICE_NAME} | egrep "desiredCount" | head -n 1 | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
            if [ ${DESIRED_COUNT} = "0" ]; then
                DESIRED_COUNT="1"
            fi
            aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}
        "
      }
    }
  }
}
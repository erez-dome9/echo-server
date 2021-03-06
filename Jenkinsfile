pipeline {
    parameters {
        string(name: 'region', defaultValue: 'us-east-1', description: 'AWS region')
        string(name: 'ecr_registry', description: 'AWS ECR registry. i.g 1234567789.dkr.ecr.us-east-1.amazonaws.com/my-repo')
        string(name: 'branch', defaultValue: 'main', description: 'Source code branch')
    }
    environment {
        region = 'us-east-1'
        registry = '${ecr_registry}'
        ECRURL = 'https://${ecr_registry}'
        ECRCRED = 'ecr:us-east-1:echo-server'
        CLUSTER_NAME='echo-server'
        SERVICE_NAME='echo-server-service'
        TASK_FAMILY='echo-server'
    }
    agent any
    stages {
        stage('Cloning Git') {
            steps {
                git branch: '${branch}',
                url: 'https://github.com/erez-dome9/echo-server.git'
                sh "ls -lat"
            }
        }
        stage('Building Image') {
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
                withAWS(credentials: 'echo-server', region: 'us-east-1') {
                    sh "./ecs-deployer.sh $CLUSTER_NAME $SERVICE_NAME $TASK_FAMILY $ecr_registry"
                }
            }
        }
    }
}
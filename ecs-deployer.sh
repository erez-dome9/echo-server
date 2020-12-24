#!/bin/bash
CLUSTER_NAME="$1"
SERVICE_NAME="$2"
TASK_FAMILY="$3"
REGISTRY="$4"

# Create a new task definition for this build
sed -e "s;%IMAGE_PLACEHOLDER%;${REGISTRY}:latest;g" echo-server-task-definition-template.json > echo-server-task-definition.json
aws ecs register-task-definition --family echo-server --cli-input-json file://echo-server-task-definition.json --region ${region}

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --region ${region} --task-definition echo-server | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services --region ${region} --cluster ${CLUSTER_NAME} --services ${SERVICE_NAME} | egrep "desiredCount" | head -n 1 | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi
aws ecs update-service --region ${region} --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}
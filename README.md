# echo-server

AWS prerequisites:
* IAM
    * IAM User (`jenkins` make sense)
    * IAM Policy - use the following policy document `required-policy-for-jenkins-user.json`. Attach this policy to jenkins user.
    * Create AWS credentials for that user (AWS_ACCESS_ID, AWS_SECRET)
* ECR
* ECS *Fargate* (use the following naming): 
    * Cluster (`echo-server`)
    * Service (`echo-server-service`)
    * Task Definition (`echo-server`)
* ALB

Notes: 
* You should make sure that ECS service security group allows inbound traffic from the ALB security group
* No need to configure targets for ALB target group. ECS service setup automatically register the targets.

Jenkins setup:
* local setup:
    * Docker engine running
    * aws-cli installed
* required plugins:
    * Amazon ECR plugin
    * CloudBees AWS Credentials Plugin
    * Docker Pipeline
    * Pipeline: AWS Steps
* setup AWS credentials item with the IAM user credentials you created at the last step (use ID: echo-server)
![](https://blog.mikesir87.io/images/ecr-addingCredentialsToJenkins.png)


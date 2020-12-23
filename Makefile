jenkins_up:
	cd local-jenkins  && \
	docker-compose up -d

jenkins_down:
	cd local-jenkins  && \
	docker-compose down

get_initial_cred:
	docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

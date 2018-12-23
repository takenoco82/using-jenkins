init:
	cd setup/jenkins && docker-compose build

start:
	cd setup/jenkins && docker-compose up -d

stop:
	cd setup/jenkins && docker-compose stop

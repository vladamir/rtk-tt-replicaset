tt-restart:
	docker-compose stop && docker-compose up -d

tt-node1:
	docker-compose exec tt-node-1 tarantoolctl enter node1

tt-node2:
	docker-compose exec tt-node-2 tarantoolctl enter node2

tt-deploy:
	ansible-playbook deploy/main.yml -i deploy/hosts.ini

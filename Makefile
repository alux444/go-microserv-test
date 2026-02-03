.PHONY: help deps docker-up-infra docker-down docker-logs

help:
	@echo "Makefile commands:"
	@echo "  deps                 - Install project dependencies"
	@echo "  docker-up-infra      - Start infrastructure services using Docker Compose"
	@echo "  docker-down          - Stop infrastructure services using Docker Compose"
	@echo "  docker-logs          - View logs of infrastructure services"
	
	
deps:
	@echo "Installing project dependencies...""
	cd api-gateway && go mod download
	cd services/user-service && go mod download

docker-up-infra:
	@echo "Starting infrastructure services using Docker Compose..."
	docker-compose up -d postgres redis rabbitmq
	@echo "PostgreSQL, Redis, and RabbitMQ services are up and running."

docker-down:
	@echo "Stopping infrastructure services using Docker Compose..."
	docker-compose down

docker-logs:
	@echo "Viewing logs of infrastructure services..."
	docker-compose logs -f
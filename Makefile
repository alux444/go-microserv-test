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

docker-build:
	@echo "Building Docker images for all services..."
	docker-compose build

docker-up:
	@echo "Starting all services using Docker Compose..."
	docker-compose up -d
	@echo "All services are up and running."
	@echo " API Gateway: http://localhost:8080"
	@echo " Inventory Service: http://localhost:50051"
	@echo " Notification Service: http://localhost:50052"
	@echo " Order Service: http://localhost:50053"
	@echo " User Service: http://localhost:50054"
	@echo "Infrastructure services (PostgreSQL, Redis, RabbitMQ) are also up and running."
	@echo ""

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

docker-restart:
	@echo "Restarting services...""
	docker-compose restart

docker-rebuild:
	@echo "Rebuilding and restarting services...""
	docker-compose down
	docker-compose build
	docker-compose up -d

tidy:
	@echo "Tidying Go modules..."
	cd api-gateway && go mod tidy
	cd services/user-service && go mod tidy
	cd services/inventory-service && go mod tidy
	cd services/notification-service && go mod tidy
	cd services/order-service && go mod tidy
	@echo "Go modules tidied for all services."
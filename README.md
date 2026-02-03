# Go Microservices with Containers

A production-ready microservices architecture built with Go, featuring containerized services, message queue communication, gRPC inter-service calls, and persistent data storage.

## Architecture Overview

This project implements a monorepo microservices architecture with the following components:

### Services
- **API Gateway** - Entry point for all client requests, routes to appropriate services
- **User Service** - Handles user management and authentication
- **Order Service** - Manages order processing and fulfillment
- **Notification Service** - Sends notifications via various channels
- **Inventory Service** - Tracks product inventory and availability

### Infrastructure Components
- **PostgreSQL** - Primary database for persistent storage
- **Redis** - Caching layer and session storage
- **RabbitMQ** - Message queue for asynchronous communication
- **gRPC** - Synchronous inter-service communication protocol

## Technology Stack

- **Language**: Go 1.21+
- **Container Orchestration**: Docker & Docker Compose
- **Message Queue**: RabbitMQ
- **Database**: PostgreSQL 15
- **Cache**: Redis 7
- **Inter-Service Communication**: gRPC
- **API Protocol**: REST (Gateway) & gRPC (Internal)

## Project Structure

```
.
├── api-gateway/           # API Gateway service
│   ├── cmd/
│   ├── internal/
│   ├── Dockerfile
│   └── go.mod
├── services/
│   ├── user-service/      # User management
│   ├── order-service/     # Order processing
│   ├── notification-service/  # Notifications
│   └── inventory-service/ # Inventory tracking
├── proto/                 # Protocol Buffer definitions
│   ├── user/
│   ├── order/
│   └── inventory/
├── pkg/                   # Shared packages
│   ├── logger/
│   ├── config/
│   └── middleware/
├── scripts/               # Utility scripts
│   ├── init-db.sh
│   └── generate-proto.sh
├── docker-compose.yml     # Container orchestration
├── docker-compose.dev.yml # Development overrides
├── Makefile              # Build automation
└── README.md
```

## Prerequisites

- **Go**: Version 1.21 or higher
- **Docker**: Version 24.0 or higher
- **Docker Compose**: Version 2.20 or higher
- **Protocol Buffers Compiler**: `protoc` version 3.x
- **Make**: For build automation

### Installing Prerequisites

**macOS:**
```bash
brew install go docker docker-compose protobuf
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install golang-go docker.io docker-compose protobuf-compiler
```

## Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd go-microservice-containers-test

# Install Go dependencies
make deps

# Generate gRPC code from proto files
make proto
```

### 2. Start Infrastructure Services

```bash
# Start PostgreSQL, Redis, and RabbitMQ
docker-compose up -d postgres redis rabbitmq

# Wait for services to be ready
make wait-for-services

# Initialize databases
make init-db
```

### 3. Start Microservices

```bash
# Start all microservices
docker-compose up -d

# Or start services individually
docker-compose up -d api-gateway user-service order-service
```

### 4. Verify Services

```bash
# Check service health
make health-check

# View logs
docker-compose logs -f

# Or view specific service logs
docker-compose logs -f api-gateway
```

## Development

### Running Services Locally (Without Docker)

```bash
# Set environment variables
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export REDIS_HOST=localhost
export RABBITMQ_URL=amqp://guest:guest@localhost:5672/

# Start infrastructure only
docker-compose up -d postgres redis rabbitmq

# Run a service
cd services/user-service
go run cmd/main.go
```

### Generating gRPC Code

When you modify `.proto` files:

```bash
# Regenerate all gRPC code
make proto

# Or generate for specific service
protoc --go_out=. --go-grpc_out=. proto/user/*.proto
```

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
make test-coverage

# Run integration tests
make test-integration

# Run specific service tests
cd services/user-service
go test ./...
```

### Code Quality

```bash
# Run linter
make lint

# Format code
make fmt

# Run security checks
make security-check
```

## Configuration

### Environment Variables

Each service can be configured using environment variables:

```bash
# Database
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=microservices
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=

# RabbitMQ
RABBITMQ_URL=amqp://guest:guest@rabbitmq:5672/

# Service Ports
API_GATEWAY_PORT=8080
USER_SERVICE_PORT=50051
ORDER_SERVICE_PORT=50052
INVENTORY_SERVICE_PORT=50053
NOTIFICATION_SERVICE_PORT=50054

# Logging
LOG_LEVEL=info
LOG_FORMAT=json
```

### Configuration Files

Services use a hierarchical configuration:
1. Default configuration in code
2. Configuration file (config.yaml)
3. Environment variables (highest priority)

## Communication Patterns

### gRPC (Synchronous)

Used for request-response patterns where immediate feedback is needed:

```go
// Example: API Gateway calling User Service
conn, err := grpc.Dial("user-service:50051", grpc.WithInsecure())
client := pb.NewUserServiceClient(conn)
response, err := client.GetUser(ctx, &pb.GetUserRequest{Id: userId})
```

### Message Queue (Asynchronous)

Used for event-driven communication and background tasks:

```go
// Example: Publishing order created event
ch.Publish("", "order.created", false, false,
    amqp.Publishing{
        ContentType: "application/json",
        Body:        json.Marshal(order),
    })
```

## Database Management

### Migrations

```bash
# Run migrations
make migrate-up

# Rollback migrations
make migrate-down

# Create new migration
make migrate-create NAME=add_users_table
```

### Database Access

Each service has its own database schema to maintain separation:

- `user_service` - User and authentication data
- `order_service` - Order and transaction data
- `inventory_service` - Product and stock data
- `notification_service` - Notification logs and templates

## Monitoring and Observability

### Health Checks

Each service exposes health endpoints:
- HTTP: `GET /health`
- gRPC: `Check()` method on health service

### Logs

Structured logging with configurable output:
```bash
# View aggregated logs
docker-compose logs -f

# View specific service
docker-compose logs -f user-service

# Filter by log level
docker-compose logs -f | grep ERROR
```

### Metrics (Future Enhancement)

- Prometheus for metrics collection
- Grafana for visualization
- Service-level metrics (latency, throughput, errors)

## API Documentation

### REST API (API Gateway)

API documentation is available at:
- Swagger UI: http://localhost:8080/swagger
- OpenAPI spec: http://localhost:8080/swagger.json

### gRPC Services

Protocol Buffer definitions serve as documentation. Generate documentation with:

```bash
make proto-docs
```

## Deployment

### Production Build

```bash
# Build all services
make build

# Build Docker images
make docker-build

# Tag and push to registry
make docker-push REGISTRY=your-registry.com
```

### Kubernetes Deployment (Future)

Kubernetes manifests will be added to support:
- Horizontal Pod Autoscaling
- Service mesh integration (Istio/Linkerd)
- ConfigMaps and Secrets management
- Persistent Volume Claims for databases

## Troubleshooting

### Services Won't Start

```bash
# Check Docker daemon
docker ps

# Check service logs
docker-compose logs service-name

# Restart services
docker-compose restart

# Clean restart
docker-compose down -v
docker-compose up -d
```

### Database Connection Issues

```bash
# Verify PostgreSQL is running
docker-compose ps postgres

# Check database logs
docker-compose logs postgres

# Test connection
docker-compose exec postgres psql -U postgres -d microservices
```

### RabbitMQ Connection Issues

```bash
# Check RabbitMQ status
docker-compose ps rabbitmq

# Access management UI
open http://localhost:15672
# Default credentials: guest/guest

# View queue status
docker-compose exec rabbitmq rabbitmqctl list_queues
```

## Performance Tuning

### Database Optimization
- Connection pooling configured per service
- Index optimization on frequently queried columns
- Query timeout settings

### Redis Caching
- Cache frequently accessed data
- Set appropriate TTL values
- Use cache-aside pattern

### Message Queue
- Consumer prefetch settings
- Message acknowledgment modes
- Dead letter queues for failed messages

## Security Considerations

- ✅ Environment variables for secrets
- ✅ Network isolation via Docker networks
- ✅ Service-to-service authentication (JWT)
- ✅ Input validation on all endpoints
- ⏳ TLS/mTLS for gRPC (planned)
- ⏳ Secret management with HashiCorp Vault (planned)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Coding Standards

- Follow Go best practices and idioms
- Run `gofmt` and `golint` before committing
- Write tests for new features
- Update documentation as needed

## License

[MIT License](LICENSE)

## Contact

Project Maintainer - [your-email@example.com](mailto:your-email@example.com)

Project Link: [https://github.com/yourusername/go-microservice-containers-test](https://github.com/yourusername/go-microservice-containers-test)

## Acknowledgments

- [Go gRPC](https://grpc.io/docs/languages/go/)
- [RabbitMQ Tutorials](https://www.rabbitmq.com/getstarted.html)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Microservices Patterns](https://microservices.io/patterns/)

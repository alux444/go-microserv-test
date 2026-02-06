FROM golang:1.23-alpine

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build
RUN go build -o main ./cmd/main.go

EXPOSE 50054

CMD ["./main"]
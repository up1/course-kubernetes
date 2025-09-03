# Use official Golang image for Go 1.25
FROM golang:1.25-alpine AS build

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go app
RUN go build -o main .

FROM alpine:latest
WORKDIR /app
COPY --from=build /app .
EXPOSE 8080
CMD ["./main"]
# Build stage
FROM golang:1.21 AS builder

WORKDIR /app

# Copy only go.mod (go.sum optional)
COPY go.mod ./
RUN go mod tidy

# Copy source code
COPY . .

# Build the binary
RUN go build -o main .

# Final stage: lightweight runtime
FROM gcr.io/distroless/base

WORKDIR /app

# Copy binary and static files
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]

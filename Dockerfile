FROM golang:1.22-alpine

WORKDIR /app

RUN apk add --no-cache git curl && \
    go install github.com/cosmtrek/air@latest

COPY go.mod go.sum ./
RUN go mod download

COPY . .

EXPOSE 8080 9090

CMD ["air", "-c", ".air.toml"]

FROM golang:1.22-alpine AS builder

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /server .

FROM alpine:3.20

RUN apk add --no-cache ca-certificates
COPY --from=builder /server /server
EXPOSE 8080
USER 1001:1001
ENTRYPOINT ["/server"]

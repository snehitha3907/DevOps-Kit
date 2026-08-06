# last_verified: 2026-08-06 · Docker n/a

FROM golang:1.22-alpine

WORKDIR /app

COPY main.go .

RUN go build -o server main.go

EXPOSE 8080

CMD ["./server"]

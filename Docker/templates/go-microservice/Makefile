# last_verified: 2026-08-05 · Docker n/a

.PHONY: build run test clean docker-build docker-run

build:
	go build -o bin/server ./main.go

run: build
	./bin/server

test:
	go test ./...

clean:
	rm -rf bin/

docker-build:
	docker build -t go-microservice .

docker-run: docker-build
	docker run -p 8080:8080 go-microservice
FROM alpine:latest

RUN echo "I'm building my first image from a Dockerfile" && \
    apk add --no-cache curl

CMD ["echo", "Hello — this image was built from a Dockerfile!"]

FROM alpine:latest

RUN apk add --no-cache figlet

CMD ["figlet", "hello docker"]

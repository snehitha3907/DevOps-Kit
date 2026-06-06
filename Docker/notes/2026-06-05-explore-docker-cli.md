# Exploring Docker CLI

I installed Docker and ran my first container. Here's what I learned poking around.

## Checking if Docker works

Ran `docker --version` to confirm it's there. Then `docker ps` shows running containers — nothing yet.

## Pulling images

Did `docker pull nginx` to download the official nginx image. It pulled several layers. `docker images` lists all downloaded images with their sizes.

## Running containers

Started nginx with port mapping: `docker run -d --name my-nginx -p 8080:80 nginx`. The `-d` runs it detached (background). Opened `http://localhost:8080` in browser — it worked!

## Inspecting what's running

`docker ps` shows my-nginx is up. `docker ps -a` includes stopped containers too.

## Stopping and cleaning up

To stop: `docker stop my-nginx`. To remove: `docker rm my-nginx`. For full cleanup: `docker system prune` removes unused data.

## Got stuck on

The `sudo` requirement. Without it, I get "permission denied" errors. I could add my user to the docker group to skip sudo, but that's a security tradeoff.
# Exploring the Docker CLI — images, containers, and Docker Hub

I installed Docker and started poking around the CLI. Here's what I tried.

First I checked the version:

    docker --version

Then I pulled hello-world and ran it:

    docker pull hello-world
    docker run hello-world

It printed a welcome message.

I listed my images:

    docker images

Just hello-world.

I checked running containers:

    docker ps

Nothing — hello-world already exited. I listed all containers including stopped ones:

    docker ps -a

There it was.

I searched Docker Hub:

    docker search nginx

A list of nginx images came back. I pulled one and ran it detached:

    docker pull nginx
    docker run -d --name my-nginx -p 8080:80 nginx

`docker ps` showed it running. I hit localhost:8080 and saw the nginx welcome page.

I cleaned up:

    docker stop my-nginx
    docker rm my-nginx
    docker rmi nginx

I also ran `docker system df` to see disk usage.

That's the basics — pull, run, list, stop, remove. Next I'll write a Dockerfile.

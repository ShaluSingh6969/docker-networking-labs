# WHAT IS A CONTAINER

- Layers of image (mostly linux base image, because small in size)
- A way to package application with all the necessary dependencies and configuration
- Portable artifact (image and when we start it that creates the container env)
- lives in Container Repository (companies can have private repositories)
- Public repository for Docker (Docker Hub)

## How containers improved application development

- do not need install all the depedent servies separately
- containers have own isolated environment, packaged with all needed configuration
- one command to install the app regardless of operating system.
- we can run same app with different version without any conflict
- No environmental configuration needed on server - except Docker Runtime

## pulling containers from docker hub public repository

```
docker pull image_name:version
```

## pulling and running at the same time

```
docker run -d(detached mode) -e(environment variable) --name<user_defined_container_name> image_name:version
```

## to check running containers

```
docker ps
```

## to check all the containers whether running or not

```
docker ps -a
```

## Docker vs VM

- both are virtualization tool
- docker virtualizes the applications layer, uses the kernel of the host.
- VM has application layer and it's own kernel, virtualized the whole OS.

## Basic docker commands

```
docker pull <image(repo:tag)>
docker run <image(repo:tag)>
docker start <container_id>
docker stop <container_id>
docker ps
docker images <image_id>
docker exec -it <container_id> ( to go inside container and run some commands)
docker logs <container_id> <container_name> <shell>(/bin/bash or sh)
```

## to remove docker images and containers

```
docker rmi image_name:tag or image_id
docker rm container_id

# always remove container first to remove image, otherwise use docker rmi -f to force remove not recommended.

```

## CONTAINER is a running environment for IMAGE

- has it's own virtual file system (virtual means gets omitted when container is deleted)
- port binded: used to talk to the application running inside of container
- application image: postgres, redis, etc

## How to access container services

- mapping container port with host port with option below

```
docker run -p <host_port>:<container_port> <image>
```

## Docker Network

Docker creates it's isolated docker network where containers run.

- if we deploy containers in the same network they can communicate just using their names.
- from outside they require the full address with port.

Some docker network commands

```
docker network ls
docker network create <network_name>
docker run -p 27017:27017 -d -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --net mongo-network mongo
```

## Docker compose

Used to run multiple containers in one go and create a shared network for all the services defined inside docker compose file itself, hence all of them can communicate together.

```
docker-compose -f <docker compose file path> up
docker-compose -f <docker compose file path> down
```

## Docker File

A blueprint for building images

- FROM node : means base image node, node is already installed inside container 
- ENV: to define environment variable
- RUN: to run linux command, but they run only inside container and perform any action inside container only.
- COPY: this is used to copy the files from host machine to container.
- CMD: executes an entry point linux command

## to build docker image

```
docker build -t my_app:1.0 <location of docker file>
```

## To debug failing container at runtime

```
docker run -it --entrypoint sh your-image
```

## command to remove all stopped containers
```
docker container prune
```

## docker volumes

a directory or folder in the host is mounted to a directory or folder in the container.

### 3 Volume Types

1. Host volume - docker run -v <host_dir>:<container_dir>
2. Anonymous volume - docker run -v <only_container_dir> . container creates the dir on host (don't know the name)
3. Named volumes - modification of anonymous volume, we can provide name - docker run -v name:<container_dir>


### docker compose 

we can define the volumes inside docker compose - example is given in docker-compose.yaml file.
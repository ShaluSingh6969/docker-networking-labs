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

# Topics need to be Covered

## docker networks
- Bridge networks
- Custom networks
- Docker DNS
- Container communication

## Labs
- App + DB setup
- Multi-container networking
- Troubleshooting exercises

## Key Learnings
- Containers communicate via service names
- Port mapping exposes services externally


### virtual file system is filled can't create any more containers

```
docker system prune
```

### docker running slow

```
docker stats
docker top
docker inspect
```

### can't connect to docker client

```
docker context ls
```

A Docker context is basically a saved configuration that tells Docker:

“Which Docker daemon/environment should I talk to?”

By default, Docker talks to your local Docker engine, but contexts let you switch between:

local Docker
remote servers
Docker Desktop
cloud environments
Kubernetes-enabled environments

without changing commands.

```
docker context create my-server \
  --docker "host=ssh://user@server-ip"
```

## DNS issues with WSL + docker setup without docker desktop

- sometimes your docker daemon is not able to get the correct DNS inside a VPN network let's say of a company.
- hence, not able to connect to external network.
- you can check the issue if it's at WSL level or docker level by simply running

```
wsl
ping www.google.com
```

if above works it means wsl dns is working fine and issue is with the docker dns in docker network

```
docker run --rm alpine ping google.com
```
if it gives error bad request it means docker is not picking the right DNS inside the VPN 

- check ipconfig all/ in cmd 
- find the dns server under vpn network details
- check the one used in docker using sudo /etc/resolv.conf
- if both are different then use the one from ipconfig
- run below command

```
sudo vim /etc/docker/daemon.json
```

add the below data

```
{
  "dns": <vpn_dns_server from ipconfig>
}
```

- save the file and again try the ping request


## Docker / WSL development environment without docker desktop

In Windows Subsystem for Linux, networking determines how Linux services (Docker, Flask, Node, etc.) communicate with Windows and the outside world.

Two main modes exist:

- NAT mode (stable, recommended)
- Mirrored mode (advanced, experimental behavior)

### NAT Mode (Recommended)

Inside your windows .wslconfig

```
[wsl2]
networkingMode=nat
localhostForwarding=true
```
#### Architecture

![WSL NAT Architecture](./media/wsl%20NAT%20architecture.png)


#### How it works

- WSL runs inside a virtual network
- Windows acts as a gateway
- Ports are explicitly forwarded via localhost

Example:

```
python3 -m http.server 8000
```

Accessible from Windows:

```
curl http://localhost:8000
```
#### Advantages

- Stable port forwarding
- Reliable for Docker inside WSL
- Works well with VS Code Remote WSL
- Predictable networking behavior

#### Best for

- Web development (Flask, Node, React)
- Docker-in-WSL workflows
- Kubernetes learning environments
- General development setups


### Mirrored Mode

Inside windows WSL config /%USERPROFILE%/.wslconf

```
[wsl2]
networkingMode=mirrored
```

#### How it works

- WSL shares the same network interface as Windows
- No NAT translation layer
- Direct access to Windows network stack

#### Intended benefits

- Same IP behavior as Windows
- Better LAN integration
- Reduced network abstraction layer

#### Common issues

Mirrored mode can cause:

- localhost services not reachable
- Docker port mapping failures
- VS Code Remote WSL connection issues
- Socket errors (e.g. 0x80072747)
- Firewall/VPN conflicts



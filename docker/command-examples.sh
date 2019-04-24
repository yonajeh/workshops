#!/usr/bin/env bash

# Build with defaults
docker build .

# Build and specify the name
docker build --tag web-client:v1 .

# Simply run a container = 1 instance of the image
# Docker will give it a random name, the console will be used by the containers output
docker run web-client:v1

# Runt the container and give it a controller name
docker run --name web-client web-client:v1

# Runt the container and: 
#  - give it a name
#  - publish a port so that is accessible from outside
#  - detach from console so that it can run as a daemon / process
docker run --detach --name web-client --publish 7777:80 web-client:v1

# List running containers
docker ps

# List all containers, incl. stopped
docker ps -a

curl http://localhost:7777/index.html
curl http://localhost:7777/index2.html

# Using shortened parameters
# docker run -d -n web-client -p 7777:80 web-client:v1

# Check logs from stdout
docker logs web-client

# Check logs in tail mode
# docker logs -f web-client

# Mount a volume / folder inside a container in order to be used there
# Note: the anti-slash / back-slash is used to tell to bash that the command has multiple lines
# Note: `pwd` command returns the current path, it can be replaced by an actual path from host system
docker run \
--detach \
--name web-client \
--publish 7777:80 \
--volume `pwd`:/usr/share/nginx/html \
web-client:v1

# This time index3.html will become available, since it is present in the external volume
# The external volume overrides the files from the container for the specified path  
curl http://localhost:7777/index3.html

# We can stop and start a container, nothing will be lost in the meantime
# Send a stop signal to process inside container and wait for it to stop with a precise delay
docker stop web-client
docker start web-client

# Just kill the process inside a container and send a sigkill signal for a controller stop
docker kill -s SIGKILL web-client
docker kill -s SIGHUP web-client

# Remove the container
docker rm web-client

# You can enforce the removal
# docker rm -f web-client
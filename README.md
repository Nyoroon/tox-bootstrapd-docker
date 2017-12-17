[![Docker Build Status](https://img.shields.io/docker/build/nyoroon/tox-bootstrapd.svg)](https://hub.docker.com/r/nyoroon/tox-bootstrapd/)
[![ImageLayers Size](https://img.shields.io/imagelayers/image-size/nyoroon/tox-bootstrapd/latest.svg)](https://hub.docker.com/r/nyoroon/tox-bootstrapd/)

# Dockerized tox-bootstrapd based on Alpine linux

This image uses autoconfiguration and updates bootstrap nodes on every lauch.
All available configuration parameters you can see in `.env.example`.
If you don't want to use autoconfiguration from environment variables then just
put your config file in /etc/tox-bootstrap.conf with volume or modifying
Dockerfile.
If you don't want to autoupdate bootstrap nodes every lauch then set environment
variable `TOX_UPDATE_NODES` to `no`.

## How to use

### Using docker-compose
1. Copy .env.example to .env and edit it
2. Change ports in docker-compose.yml (optional)
3. `docker-compose build` (optional)
4. `docker-compose up -d`

### Using docker
1. Copy .env.example to .env and edit it
2. `docker build -t nyoroon/tox-bootstrapd .` (optional)
3. Run image with:
    ```
    docker run --detach --name tox-bootstrapd \
      --volume toxdata:/var/lib/tox-bootstrapd \
      --port 33445:33445/udp --port 33445:33445 \
      --env-file .env nyoroon/tox-bootstrapd
    ```

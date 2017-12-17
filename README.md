# Dockerized tox-bootstrapd on Alpine linux

## How to use

### Using docker-compose
1. Copy .env.example to .env and edit it
2. Change ports in docker-compose.yml (optional)
3. `docker-compose build` (optional)
4. `docker-compose up -d`

### Using docker
1. Copy .env.example to .env and edit it
2. `docker build -t nyoroon/tox-bootstrapd .` (optional)
3.
```
docker run --detach --name tox-bootstrapd \
  --volume toxdata:/var/lib/tox-bootstrapd \
  --port 33445:33445/udp --port 33445:33445 \
  --env-file .env nyoroon/tox-bootstrapd
```

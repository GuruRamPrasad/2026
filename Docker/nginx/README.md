# NGINX Docker

This project runs an NGINX web server using Docker.

## Project Structure

```text
nginx-app/
│
├── Dockerfile
├── README.md
├── index.html
└── ...
```

## Prerequisites

Make sure Docker is installed and running.

Check Docker version:

```bash
docker --version
```

## Build Docker Image

Go to the project directory:

```bash
cd nginx-app
```

Build the Docker image:

```bash
docker build -t my-nginx-app .
```

Check the created image:

```bash
docker images
```

## Run NGINX Container

Run the container:

```bash
docker run -d -p 8080:80 --name nginx-container my-nginx-app
```

### Port Mapping

```text
Host Port     Container Port
8080    --->  80
```

NGINX is running on port `80` inside the container and is accessible through port `8080` on the host.

## Check Container Status

```bash
docker ps
```

To see all containers:

```bash
docker ps -a
```

## Access NGINX

Open a browser and access:

```text
http://localhost:8080
```

If running on a remote server, use:

```text
http://SERVER-IP:8080
```

## View Container Logs

```bash
docker logs nginx-container
```

To follow the logs:

```bash
docker logs -f nginx-container
```

Press `Ctrl+C` to stop following the logs.

## Stop NGINX Container

```bash
docker stop nginx-container
```

## Start the Container Again

```bash
docker start nginx-container
```

## Restart the Container

```bash
docker restart nginx-container
```

## Remove the Container

First stop the container:

```bash
docker stop nginx-container
```

Then remove it:

```bash
docker rm nginx-container
```

## Remove Docker Image

```bash
docker rmi my-nginx-app
```

## Complete Commands

### Build

```bash
docker build -t my-nginx-app .
```

### Run

```bash
docker run -d -p 8080:80 --name nginx-container my-nginx-app
```

### Check

```bash
docker ps
```

### Access

```text
http://localhost:8080
```

### Stop

```bash
docker stop nginx-container
```

### Start

```bash
docker start nginx-container
```

### Remove

```bash
docker rm nginx-container
```

# Node.js Application Docker Setup

This README explains how to prepare and run a Node.js application using Docker.

## Project Structure

The Node.js project should have the following structure:

```text
my-node-app/
├── Dockerfile
├── .dockerignore
├── package.json
├── package-lock.json
└── server.js
```

> The `Dockerfile` is already available in the project.

---

## 1. package.json

The Node.js application should contain a `package.json` file.

Example:

```json
{
  "name": "my-node-app",
  "version": "1.0.0",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^5.1.0"
  }
}
```

---

## 2. package-lock.json

Generate the `package-lock.json` file by running:

```bash
npm install
```

This file helps Docker install the same dependency versions.

---

## 3. .dockerignore

Create a file named:

```text
.dockerignore
```

Add the following:

```text
node_modules
npm-debug.log
.git
.gitignore
Dockerfile
.dockerignore
```

This prevents unnecessary files from being copied into the Docker image.

---

## 4. Application File

For example, the application can have:

```text
server.js
```

The application should listen on the same port that is exposed in the Dockerfile.

For example:

```javascript
const express = require("express");

const app = express();

const PORT = 3000;

app.get("/", (req, res) => {
    res.send("Node.js application is running!");
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

---

# Docker Commands

## 5. Build Docker Image

Go to the Node.js project directory:

```bash
cd my-node-app
```

Build the Docker image:

```bash
docker build -t my-node-app .
```

Check the image:

```bash
docker images
```

---

## 6. Run Docker Container

Run the container:

```bash
docker run -d -p 3000:3000 --name my-node-app my-node-app
```

Check running containers:

```bash
docker ps
```

---

## 7. Check Application

Open a browser and access:

```text
http://localhost:3000
```

You should see:

```text
Node.js application is running!
```

---

## 8. Check Container Logs

To view application logs:

```bash
docker logs my-node-app
```

To continuously view logs:

```bash
docker logs -f my-node-app
```

---

## 9. Stop Container

```bash
docker stop my-node-app
```

---

## 10. Start Container Again

```bash
docker start my-node-app
```

---

## 11. Remove Container

Stop the container first:

```bash
docker stop my-node-app
```

Then remove it:

```bash
docker rm my-node-app
```

---

## 12. Remove Docker Image

```bash
docker rmi my-node-app
```

---

# Complete Flow

The basic Docker workflow is:

```bash
cd my-node-app

docker build -t my-node-app .

docker run -d -p 3000:3000 --name my-node-app my-node-app

docker ps

docker logs my-node-app
```

Application URL:

```text
http://localhost:3000
```

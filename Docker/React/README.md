# React.js Docker

This project provides a production-ready Dockerfile for a React.js application.

The Docker image uses a multi-stage build:

1. Node.js builds the React application.
2. Nginx serves the generated static files.
3. The final image does not contain Node.js, npm, or the source code.

## Files

```text
react-app/
├── Dockerfile.react
├── README.md
├── package.json
├── package-lock.json
├── src/
├── public/
└── ...
```

## Dockerfile

The Dockerfile is named:

```text
Dockerfile.react
```

It uses:

- Node.js 20 Alpine for building
- Nginx Alpine for production
- Multi-stage Docker build
- Port 80 for the Nginx runtime

## Prerequisites

Make sure Docker is installed:

```bash
docker --version
```

The React project should contain:

```text
package.json
package-lock.json
```

The `package.json` must have a build script, for example:

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  }
}
```

## Build Docker Image

From the React project directory:

```bash
docker build -f Dockerfile.react -t react-app:1.0 .
```

Check the image:

```bash
docker images
```

## Run Container

Run the container:

```bash
docker run -d   --name react-app   -p 8080:80   react-app:1.0
```

Open the application:

```text
http://localhost:8080
```

## Check Container

```bash
docker ps
```

View logs:

```bash
docker logs react-app
```

## Stop Container

```bash
docker stop react-app
```

## Remove Container

```bash
docker rm react-app
```

## Remove Image

```bash
docker rmi react-app:1.0
```

## Why Multi-Stage Build?

The first stage contains Node.js and all build dependencies:

```dockerfile
FROM node:20-alpine AS builder
```

It runs:

```bash
npm ci
npm run build
```

The second stage contains only Nginx:

```dockerfile
FROM nginx:alpine
```

The generated React files are copied into:

```text
/usr/share/nginx/html
```

This keeps the production image smaller and avoids putting Node.js and development dependencies into the runtime image.

## Vite React Applications

For Vite-based React applications, the production build is generated in:

```text
dist/
```

Therefore the Dockerfile uses:

```dockerfile
COPY --from=builder /app/dist /usr/share/nginx/html
```

## Create React App

If the project uses the older Create React App (CRA) and generates:

```text
build/
```

change:

```dockerfile
COPY --from=builder /app/dist /usr/share/nginx/html
```

to:

```dockerfile
COPY --from=builder /app/build /usr/share/nginx/html
```

## Environment Variables

For Vite, variables exposed to the frontend normally need the `VITE_` prefix:

```text
VITE_API_URL=https://api.example.com
```

Example:

```bash
docker build   --build-arg VITE_API_URL=https://api.example.com   -f Dockerfile.react   -t react-app:1.0 .
```

If build arguments are required, add an `ARG` declaration to the Dockerfile before `npm run build`.

Remember that frontend environment variables are embedded into the generated JavaScript and are **not secrets**. Do not put passwords, private keys, or other sensitive credentials into React build-time variables.

## Recommended .dockerignore

Create a `.dockerignore` file:

```text
node_modules
npm-debug.log
.git
.gitignore
Dockerfile*
README.md
dist
build
.env
.env.*
```

This prevents unnecessary files from being sent to the Docker build context.

## Production Flow

```text
Developer
   |
   v
Git Repository
   |
   v
Docker Build
   |
   +--> Node.js 20
   |      |
   |      +--> npm ci
   |      |
   |      +--> npm run build
   |
   v
React dist/
   |
   v
Nginx Alpine
   |
   v
Port 80
   |
   v
Users
```

## Kubernetes

The same image can be pushed to a container registry and deployed to Kubernetes.

Example image:

```text
registry.example.com/react-app:1.0
```

The Kubernetes Service can expose the Nginx container on port 80.

## Notes

- Use `npm ci` when `package-lock.json` is available.
- Use a supported Node.js LTS version for the application.
- Nginx is used only as the production web server.
- Do not copy `node_modules` from the local machine into the image.
- For React Single Page Applications, Nginx may need an SPA fallback configuration so routes such as `/users` or `/dashboard` return `index.html`.

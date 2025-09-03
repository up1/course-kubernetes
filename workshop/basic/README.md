# Basic Workshop
* Basic of container with Docker
  * Build image from Dockerfile
  * Run container
  * Working with docker compose

## 1. Structure of Project
* Web with Go
* Database with MongoDB

## 2. Build image and start container of API

Build image
```
$docker image build -t api:1.0 ./api
```

Create and start container
```
$docker container run -d -p 8080:8080 api:1.0
```

Access in web browser
* http://localhost:8080


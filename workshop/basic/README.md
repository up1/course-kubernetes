# Basic Workshop
* Basic of container with Docker
  * Build image from Dockerfile
  * Run container
  * Working with docker compose

## 1. Structure of Project
* Web with Go
* Database with MongoDB

## 2. Build image and start container of MongoDB
Build image
```
$docker image build -t db:1.0 ./mongo
```

Create and start container
```
$docker container run -d -p 27017:27017 --name db db:1.0
$docker container ps
```

Access to container
```
$docker container exec -it db bash
```

Check data in mongodb
```
$mongosh --username admin --password password
$use products_db;
$db.products.find()
```


## 3. Build image and start container of API

Build image
```
$docker image build -t api:1.0 ./api
```

Create and start container
```
$docker network create demo
$docker container run -d -p 27017:27017 --name db --network demo db:1.0
$docker container run -d -p 8080:8080 --name api --network demo -e MONGODB_URI="mongodb://admin:password@db:27017/?directConnection=true" api:1.0
```

Access in web browser
* http://localhost:8080/health
* http://localhost:8080/products

## 4. Working with Docker compose

Build image
```
$docker compose build db
$docker compose build api
```

Create and start container
```
$docker compose up -d db
$docker compose up -d api
$docker compose ps
```

Access in web browser
* http://localhost:8080/health
* http://localhost:8080/metrics
* http://localhost:8080/products

Start all in a single line
```
$docker compose up -d --build
$docker compose ps
```

Delete all containers
```
$docker compose down
```


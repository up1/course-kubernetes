# Workshop with NodeJS and MySQL database
* REST API with NodeJS 24 and Express library
* Database with MySQL 8

## 1. Working with docker compose
```
$docker compose build
$docker compose up -d

$docker compose ps   
NAME                  IMAGE             COMMAND                  SERVICE   CREATED          STATUS                    PORTS
demo-nodejs-api-1     demo-nodejs-api   "docker-entrypoint.s…"   api       31 seconds ago   Up 20 seconds             0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp
demo-nodejs-db-1      mysql:8           "docker-entrypoint.s…"   db        32 seconds ago   Up 30 seconds (healthy)   3306/tcp, 33060/tcp
demo-nodejs-redis-1   redis:8           "docker-entrypoint.s…"   redis     32 seconds ago   Up 30 seconds (healthy)   6379/tcp
```

List of URLs
* GET / - Health check
* GET /api/users - Get users with Redis caching
* POST /api/users - Create new users
* GET /metrics - Prometheus metrics

## 2. Working with NGINX + Reverse proxy
```
$docker compose down
$docker compose build

$docker compose up -d --scale api=3
$docker compose ps                 
NAME                  IMAGE               COMMAND                  SERVICE   CREATED              STATUS                        PORTS
demo-nodejs-api-1     demo-nodejs-api     "docker-entrypoint.s…"   api       About a minute ago   Up About a minute (healthy)   3000/tcp
demo-nodejs-api-2     demo-nodejs-api     "docker-entrypoint.s…"   api       About a minute ago   Up About a minute (healthy)   3000/tcp
demo-nodejs-api-3     demo-nodejs-api     "docker-entrypoint.s…"   api       About a minute ago   Up About a minute (healthy)   3000/tcp
demo-nodejs-db-1      mysql:8             "docker-entrypoint.s…"   db        About a minute ago   Up About a minute (healthy)   3306/tcp, 33060/tcp
demo-nodejs-nginx-1   demo-nodejs-nginx   "/docker-entrypoint.…"   nginx     About a minute ago   Up About a minute             0.0.0.0:8000->80/tcp, [::]:8000->80/tcp
demo-nodejs-redis-1   redis:8             "docker-entrypoint.s…"   redis     About a minute ago   Up About a minute (healthy)   6379/tcp
```

Access to nginx
```
$curl http://localhost:8000/
```
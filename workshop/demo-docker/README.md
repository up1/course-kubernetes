# Workshop with container

## 1. Docker
Build
```
$docker image build -t hello:1.0 .
```

Run
```
$docker container run -d -p 8888:80 --name demo hello:1.0 .
```

## 2. Docker compose
Build
```
$docker compose build
```

Run
```
$docker compose up -d
$docker compose ps
```

## 3. Docker swarm
Initial
```
$docker swarm init
$docker node ls
```

Deploy
```
$docker stack deploy --compose-file docker-compose.yml dev
$docker stack ls
$docker service ls
```

Scale service
```
$docker service ls
$docker service scale dev_hello=5
```


## 4. Kubernetes
```
# Start minikune
$minikube start
$minikube status

# Check nodes in cluster
$kubectl get node

# Deploy 
$kubectl apply -f hello_deployment.yml
$kubectl get pod
$kubectl get deployment
$kubectl get rs

$kubectl apply -f service_service.yml
$kubectl get service

# Forward port of service
# https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/

$kubectl port-forward service/service 8080:80

$curl http://localhost:8080/
```

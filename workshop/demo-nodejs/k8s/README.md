# Kubernetes Manifests for Demo Node.js Application

This directory contains Kubernetes manifest files to deploy the demo Node.js application with MySQL and Redis to a Minikube cluster.

## Architecture

The deployment consists of:
- **API Service**: Node.js application (2 replicas)
- **MySQL Database**: MySQL 8 with persistent storage
- **Redis Cache**: Redis 8 with persistent storage
- **NGINX Ingress**: For external access

## Files Overview

| File | Description |
|------|-------------|
| `namespace.yaml` | Creates the demo-nodejs namespace |
| `configmaps.yaml` | Configuration data for all services |
| `secrets.yaml` | Sensitive data (passwords) |
| `persistent-volumes.yaml` | PV and PVC for MySQL and Redis data |
| `mysql-pod.yaml` | MySQL database pod |
| `redis-pod.yaml` | Redis cache pod |
| `database-services.yaml` | Services for MySQL and Redis |
| `api-deployment.yaml` | API application deployment |
| `api-service.yaml` | Service for API |
| `api-ingress.yaml` | Ingress for external access |
| `deploy.sh` | Automated deployment script |
| `cleanup.sh` | Cleanup script |

## Prerequisites

1. **Minikube**: Running and accessible
   ```bash
   minikube start
   ```

2. **Docker**: Available in your environment

3. **kubectl**: Configured to work with your minikube cluster

## Quick Deployment

### Option 1: Automated Deployment
Run the deployment script:
```bash
./k8s/deploy.sh
```

### Option 2: Manual Deployment
Apply manifests in order:
```bash
# 1. Create namespace `demo-nodejs`
kubectl apply -f k8s/namespace.yaml
kubectl get ns

# 2. Create configuration
kubectl apply -f k8s/configmaps.yaml
kubectl get configmap -n demo-nodejs

kubectl apply -f k8s/secrets.yaml
kubectl get secret -n demo-nodejs

# 3. Create storage
kubectl apply -f k8s/persistent-volumes.yaml
kubectl get pv -n demo-nodejs
kubectl get pvc -n demo-nodejs

# 4. Deploy databases
kubectl apply -f k8s/mysql-pod.yaml
kubectl apply -f k8s/redis-pod.yaml
kubectl get pod -n demo-nodejs
kubectl describe pod -n demo-nodejs


kubectl apply -f k8s/database-services.yaml
kubectl get service -n demo-nodejs

# Wait for databases to be ready
kubectl wait --for=condition=Ready pod/mysql-pod -n demo-nodejs --timeout=300s
kubectl wait --for=condition=Ready pod/redis-pod -n demo-nodejs --timeout=300s

# 5. Build and deploy API (make sure to use minikube docker env)
eval $(minikube docker-env)
docker build -t demo-nodejs-api:latest ./api/

kubectl apply -f k8s/api-deployment.yaml
kubectl get pod -n demo-nodejs
kubectl get rs -n demo-nodejs
kubectl get deploy -n demo-nodejs

kubectl apply -f k8s/api-service.yaml
kubectl get service -n demo-nodejs
#Forward port of api-service with port=3000
kubectl port-forward svc/api-service 3000:3000 -n demo-nodejs

# 6. Create ingress
minikube addons enable ingress
kubectl apply -f k8s/api-ingress.yaml
```

## Access the Application

1. Get minikube IP:
   ```bash
   minikube ip
   ```

2. Add entry to `/etc/hosts`:
   ```
   <MINIKUBE_IP> demo-nodejs.local
   ```

3. Access the application:
   ```
   http://demo-nodejs.local
   ```

## Monitoring and Debugging

### Check pod status:
```bash
kubectl get pods -n demo-nodejs
```

### View logs:
```bash
# API logs
kubectl logs -f deployment/api-deployment -n demo-nodejs

# MySQL logs
kubectl logs -f mysql-pod -n demo-nodejs

# Redis logs
kubectl logs -f redis-pod -n demo-nodejs
```

### Check services:
```bash
kubectl get svc -n demo-nodejs
```

### Check ingress:
```bash
kubectl get ingress -n demo-nodejs
```

### Port forwarding (alternative access):
```bash
# Forward API service
kubectl port-forward svc/api-service 3000:3000 -n demo-nodejs

# Forward MySQL
kubectl port-forward mysql-pod 3306:3306 -n demo-nodejs

# Forward Redis
kubectl port-forward redis-pod 6379:6379 -n demo-nodejs
```

## Configuration Details

### Environment Variables
The API uses these environment variables:
- `DATABASE_URL`: Full MySQL connection string
- `DATABASE_HOST`: MySQL service hostname
- `DATABASE_PORT`: MySQL port (3306)
- `DATABASE_NAME`: Database name (mydatabase)
- `DATABASE_USER`: Database user (user)
- `DATABASE_PASSWORD`: Database password (from secret)
- `REDIS_HOST`: Redis service hostname
- `REDIS_PORT`: Redis port (6379)

### Storage
- **MySQL Data**: Persisted to `/tmp/mysql-data` on the host
- **Redis Data**: Persisted to `/tmp/redis-data` on the host

### Resource Limits
- **API**: 128Mi-256Mi RAM, 100m-300m CPU
- **MySQL**: 256Mi-512Mi RAM, 200m-500m CPU  
- **Redis**: 64Mi-128Mi RAM, 100m-200m CPU

## Secrets Information

The following secrets are base64 encoded:
- `MYSQL_ROOT_PASSWORD`: "rootpassword"
- `MYSQL_PASSWORD`: "password"
- `DATABASE_PASSWORD`: "password"

To update secrets, encode your values:
```bash
echo -n "your-password" | base64
```

## Cleanup

Remove all resources:
```bash
./k8s/cleanup.sh
```

Or manually:
```bash
kubectl delete namespace demo-nodejs
```

## Troubleshooting

### Common Issues

1. **Pods stuck in Pending**: Check PV creation and node resources
2. **ImagePullBackOff**: Ensure Docker images are built in minikube context
3. **Ingress not working**: Verify ingress controller is enabled and hosts file is updated
4. **Database connection fails**: Check if database pods are ready and services are created

### Useful Commands

```bash
# Describe pod for detailed information
kubectl describe pod <pod-name> -n demo-nodejs

# Get events
kubectl get events -n demo-nodejs --sort-by='.lastTimestamp'

# Execute commands in pods
kubectl exec -it mysql-pod -n demo-nodejs -- mysql -u root -p
kubectl exec -it redis-pod -n demo-nodejs -- redis-cli
```
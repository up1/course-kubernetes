# Nginx Reverse Proxy Configuration

This nginx configuration acts as a reverse proxy for the Node.js API service, providing the following features:

## Features

- **Load Balancing**: Routes requests to the API backend service
- **Rate Limiting**: Limits API requests to 100 requests per minute per IP
- **Security Headers**: Adds security headers to all responses
- **Gzip Compression**: Compresses responses to reduce bandwidth
- **Health Check**: Provides a `/health` endpoint for monitoring
- **Proper Logging**: Structured access and error logging
- **Timeout Configuration**: Configured timeouts for better reliability

## Configuration Details

### Upstream Configuration
```nginx
upstream api_backend {
    server api:3000;
}
```

### Key Routes
- `/api/*` - Proxies to the Node.js API with rate limiting
- `/metrics` - Proxies to Prometheus metrics endpoint
- `/health` - Nginx health check endpoint
- `/` - Default route proxies to the API root

### Security Features
- X-Frame-Options: SAMEORIGIN
- X-XSS-Protection: 1; mode=block
- X-Content-Type-Options: nosniff
- Content Security Policy headers
- Rate limiting on API endpoints

### Performance Features
- Gzip compression for text-based responses
- Connection keep-alive
- Proper buffering settings
- Configurable timeouts

## Usage

1. **Start the services**:
   ```bash
   docker-compose up -d
   ```

2. **Access the application**:
   - Main application: http://localhost
   - API endpoints: http://localhost/api/users
   - Health check: http://localhost/health
   - Metrics: http://localhost/metrics

3. **Stop the services**:
   ```bash
   docker-compose down
   ```

## Monitoring

- **Access Logs**: Available in `/var/log/nginx/access.log`
- **Error Logs**: Available in `/var/log/nginx/error.log`
- **Health Check**: GET `/health` returns 200 OK when nginx is healthy

## Customization

To customize the configuration:

1. Edit `nginx/nginx.config`
2. Rebuild and restart:
   ```bash
   docker-compose up -d --build nginx
   ```

## Rate Limiting

The configuration includes rate limiting:
- Zone: `api` with 10MB memory
- Rate: 100 requests per minute per IP
- Burst: 20 requests with no delay

To adjust rate limiting, modify the `limit_req_zone` and `limit_req` directives in the configuration.
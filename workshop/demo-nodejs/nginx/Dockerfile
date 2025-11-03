# Use the official nginx image
FROM nginx:alpine

# Copy the custom nginx configuration
COPY nginx.config /etc/nginx/nginx.conf

# Create log directory
RUN mkdir -p /var/log/nginx

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
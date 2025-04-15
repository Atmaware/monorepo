#!/bin/bash
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit 1
fi

# Setup variables
DOMAIN="ruminer.atmaware.com"
PROJECT_DIR=$(pwd)
SITE_CONF="$PROJECT_DIR/ruminer.conf"

# Install certbot if not installed
if ! command -v certbot &> /dev/null; then
  apt install -y certbot python3-certbot-nginx
fi

# Setup Nginx
# Copy nginx config
cp self-hosting/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy site config
cp "$SITE_CONF" /etc/nginx/sites-available/ruminer

# Create symlink if it doesn't exist
if [ ! -L /etc/nginx/sites-enabled/ruminer ]; then
  ln -s /etc/nginx/sites-available/ruminer /etc/nginx/sites-enabled/
fi

# Remove default config if it exists
if [ -L /etc/nginx/sites-enabled/default ]; then
  rm -rf /etc/nginx/sites-enabled/default
fi

# Test nginx config
nginx -t

# Start/reload nginx
systemctl start nginx || systemctl reload nginx

# Obtain SSL certificate
certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --email admin@atmaware.com

echo "Deployment setup completed!"
echo "SSL certificates have been configured by certbot."
echo "You can now run 'docker compose up -d' to start the services."

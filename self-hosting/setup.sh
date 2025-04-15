#!/bin/bash
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit 1
fi

# Change directory to self-hosting
cd $PWD

# Setup variables
DOMAIN="ruminer.atmaware.com"

# Install nginx and certbot if not installed
if ! command -v nginx &> /dev/null || ! command -v certbot &> /dev/null; then
  apt update
  apt install -y nginx certbot python3-certbot-nginx
fi

# Copy nginx config
cp ./nginx/nginx.conf /etc/nginx/nginx.conf

# Copy site config
cp ./nginx/ruminer.conf "/etc/nginx/sites-available/$DOMAIN"

# Create symlink if it doesn't exist
if [ ! -L "/etc/nginx/sites-enabled/$DOMAIN" ]; then
  ln -s "/etc/nginx/sites-available/$DOMAIN" "/etc/nginx/sites-enabled/$DOMAIN"
fi

# Remove default config if it exists
if [ -L /etc/nginx/sites-enabled/default ]; then
  rm -rf /etc/nginx/sites-enabled/default
fi

# Check if SSL certificate already exists
if [ ! -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
    # Obtain SSL certificate if it doesn't exist
    certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --email caster@atmaware.com
else
    # Renew existing certificate
    certbot renew --quiet
fi

# Test nginx config
nginx -t

# Restart nginx
systemctl restart nginx

echo "Deployment setup completed!"
echo "SSL certificates have been configured by certbot."

# Build docker images
cd docker-compose
cp .env.example .env
cp .env self-build/.env
docker compose down
docker compose up -d
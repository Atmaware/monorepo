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

# Setup Nginx
# Copy nginx config
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

# Reload nginx
systemctl reload nginx

# Install certbot
apt install -y certbot python3-certbot-nginx

# Obtain SSL certificate
certbot --nginx -d ruminer.atmaware.com

echo "Deployment setup completed!"
echo "Please ensure your SSL certificates are properly configured in the Nginx config."
echo "You can now run 'docker compose up -d' to start the services."

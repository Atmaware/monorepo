# sudo apt-get update
# sudo apt-get install -y docker.io dnsmasq
# sudo systemctl start docker
# sudo systemctl enable docker
# sudo docker pull docker.io/mailserver/docker-mailserver:latest

# DMS_GITHUB_URL="https://raw.githubusercontent.com/docker-mailserver/docker-mailserver/master"
# wget -O ./docker-compose.yml "${DMS_GITHUB_URL}/compose.yaml"
# wget -O ./mailserver.env "${DMS_GITHUB_URL}/mailserver.env"

# Append to dnsmasq.conf if not exists
DNSMASQ_LINE="address=/testdomain.local/127.0.0.1"
DNSMASQ_FILE="/etc/dnsmasq.conf"
if ! grep -qF "$DNSMASQ_LINE" "$DNSMASQ_FILE"; then
  echo "$DNSMASQ_LINE" | sudo tee -a "$DNSMASQ_FILE"
fi

# Append to resolv.conf if not exists
RESOLV_LINE="nameserver 127.0.0.1"
RESOLV_FILE="/etc/resolv.conf"
if ! grep -qF "$RESOLV_LINE" "$RESOLV_FILE"; then
  echo "$RESOLV_LINE" | sudo tee -a "$RESOLV_FILE"
fi

# Append to /etc/hosts if not exists
HOSTS_LINE="127.0.0.1 testdomain.local"
HOSTS_FILE="/etc/hosts"
if ! grep -qF "$HOSTS_LINE" "$HOSTS_FILE"; then
  echo "$HOSTS_LINE" | sudo tee -a "$HOSTS_FILE"
fi

sudo systemctl restart dnsmasq

sudo docker rm -f mailserver
sudo docker-compose up -d
sudo docker ps
sudo docker exec -it mailserver setup email add user1@testdomain.local password1
sudo docker exec -it mailserver setup email add user2@testdomain.local password2
sudo docker exec -ti mailserver setup alias add postmaster@testdomain.local user1@testdomain.local

# Manually add virtual mailbox mapping if necessary
# sudo docker exec -it mailserver bash -c 'echo "user1@testdomain.local user1@testdomain.local" >> /etc/postfix/virtual'
# sudo docker exec -it mailserver postmap /etc/postfix/virtual

# Manually update virtual mailbox mapping
# sudo docker exec -it mailserver cat /etc/postfix/main.cf
# sudo docker exec -it mailserver cat /etc/postfix/virtual

# Restart services
sudo docker exec -it mailserver postfix reload
sudo docker exec -it mailserver dovecot reload

sudo docker logs -f mailserver
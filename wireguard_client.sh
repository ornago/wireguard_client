#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Get updates and needed software
apt update
apt dist-upgrade -y
apt install tmux wireguard vim -y

# Configuration for Client
mkdir /etc/wireguard/keys
cd /etc/wireguard/keys
wg genkey | tee client_private_key | wg pubkey > client_public_key
cd ..
echo [Interface] > wg0.conf
echo PrivateKey = $(cat keys/client_private_key) >> wg0.conf
echo -n "Client IP-Address CIDR (example:10.0.0.2/24): "
read -r client_cidr
client_ip=$(echo $client_cidr | cut -d / -f 1)
echo Address = $client_cidr >> wg0.conf
echo "" >> wg0.conf
echo [Peer] >> wg0.conf
echo -n "Server Public Key: "
read -r server_public
echo PublicKey = $server_public >> wg0.conf
echo -n "Network of wireguard vpn (example: 10.0.0.0/24): "
read -r server_cidr
echo AllowedIPs = $server_cidr >> wg0.conf
echo -n "Name Serveraddress (external IP or FQDN): "
read -r server
echo Endpoint = $server:51820 >> wg0.conf
echo PersistentKeepalive = 25 >> wg0.conf

# Configuration for Server
echo ""
echo "Please add the following to your server configuration ( wg0.conf ):"
echo "-------------------------------------------------------------------"
echo [Peer]
echo PublicKey = $(cat keys/client_public_key)
echo AllowedIPs = $client_ip/32
echo "-------------------------------------------------------------------"
echo ""

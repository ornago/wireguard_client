#!/bin/bash

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
echo -n "Client IP-Addresse CIDR (example:10.0.0.2/24): "
read -r client_ip
echo Address = $client_ip >> wg0.conf
echo "" >> wg0.conf
echo [Peer] >> wg0.conf
echo -n "Server Public Key: "
read -r server_public
echo PublicKey = $server_public >> wg0.conf
echo -n "Network of wireguard vpn (example: 10.0.0.0/24): "
read -r server_ip
echo AllowedIPs = $server_ip >> wg0.conf
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

# wireguard_client_helper
Quick wireguard bash script for the client
Used on a rasbian lite 32bit pi zero created with Raspberry Pi Imager


# Installation
Download the script with the following command
```
git clone https://github.com/ornago/wireguard_client_helper.git
```

Have a look at your `/etc/apt/sources.list` file and uncomment the following line
```
# deb http://deb.debian.org/debian buster-backports main contrib non-free
```

`cd` into the `wireguard_client_helper` directory and run `chmod +x wireguard_client.sh` to make it executable.
Run the script with `./wireguard_client.sh`. Follow the steps in the shell.

#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y pwgen
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install nano htop git -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common libgmp3-dev -y
sudo apt-get install libboost-all-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get -y install python-virtualenv virtualenv

dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=2000
mkswap /mnt/myswap.swap
chmod 600 /mnt/myswap.swap
swapon /mnt/myswap.swap
echo -e "/mnt/myswap.swap none swap sw 0 0 \n" >> /etc/fstab

sudo shutdown -r now

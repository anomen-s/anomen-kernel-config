#!/bin/sh

# https://www.datovka.cz/cs/pages/instalace.html

# Debian 13

echo 'deb http://download.opensuse.org/repositories/home:/CZ-NIC:/datovka-latest/Debian_13/ /' | sudo tee /etc/apt/sources.list.d/home:CZ-NIC:datovka-latest.list
curl -fsSL https://download.opensuse.org/repositories/home:CZ-NIC:datovka-latest/Debian_13/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_CZ-NIC_datovka-latest.gpg > /dev/null
sudo apt update
sudo apt install datovka


exit

# Debian 12

echo 'deb http://download.opensuse.org/repositories/home:/CZ-NIC:/datovka-latest/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:CZ-NIC:datovka-latest.list
curl -fsSL https://download.opensuse.org/repositories/home:CZ-NIC:datovka-latest/Debian_12/Release.key | sudo tee /etc/apt/trusted.gpg.d/home_CZ-NIC_datovka-latest.asc
sudo apt update
sudo apt install datovka

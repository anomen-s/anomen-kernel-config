#!/bin/sh

# https://www.datovka.cz/cs/pages/instalace.html

echo 'deb http://download.opensuse.org/repositories/home:/CZ-NIC:/datovka-latest/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:CZ-NIC:datovka-latest.list
curl -fsSL https://download.opensuse.org/repositories/home:CZ-NIC:datovka-latest/Debian_12/Release.key | sudo tee /etc/apt/trusted.gpg.d/home_CZ-NIC_datovka-latest.asc
sudo apt update
sudo apt install datovka

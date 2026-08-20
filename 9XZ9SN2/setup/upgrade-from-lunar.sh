sudo sed -i 's|http://ports.ubuntu.com/ubuntu-ports|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
sudo apt update && sudo apt upgrade -y
sudo sed -i 's|lunar|mantic|g' /etc/apt/sources.list
sudo apt update && sudo apt upgrade -y

# Had to fix the installs for libc6
sudo apt --fix-broken install

sudo apt dist-upgrade

# use `cat /etc/os-release` to ensure you have upgraded to mantic at this point
# reboot the system

sudo do-release-upgrade


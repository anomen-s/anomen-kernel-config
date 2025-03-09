#!/bin/sh

sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service

sudo systemctl disable wpa_supplicant.service
sudo systemctl stop wpa_supplicant.service

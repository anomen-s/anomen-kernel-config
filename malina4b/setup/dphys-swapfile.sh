#!/bin/sh

# Remove swap file from /var

sudo dphys-swapfile swapoff

sudo dphys-swapfile uninstall

sudo systemctl disable dphys-swapfile.service

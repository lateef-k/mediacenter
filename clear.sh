#!/usr/bin/env sh

printf "Deleting containers\n"

podman container rm --all --force
podman volume rm --all 
sudo rm -r ./config
sudo rm -r ./data
sudo deluser media
sudo delgroup media

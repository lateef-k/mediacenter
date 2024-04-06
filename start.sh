#!/usr/bin/env sh

set -e
set -u
set -x



error_handler() {
    # Since we can't trap ERR in posix shell
    [ $? -eq 0 ] && exit
    echo "An error occurred. Exiting script."
    ./clear.sh
    exit 1
}

# Set up trap to call error_handler function when an error occurs
trap 'error_handler' EXIT

sudo useradd -M media
sudo passwd

puid=$(id --user media)
pgid=$(id --group media)

sed -i.bak "s/PUID=[0-9]\+/PUID=${puid}/g" docker-compose.yml
sed -i.bak  "s/PGID=[0-9]\+/PGID=${pgid}/g" docker-compose.yml

mkdir -pv \
    config/sonarr-config \
    config/radarr-config \
    config/prowlarr-config \
    config/qbittorrent-config \
    config/sabnzbd-config \
    config/jellyseerr-config \
    config/jellyfin-config \
    config/bazarr-config

mkdir -pv \
    data/torrents/tv \
    data/torrents/movies \
    data/torrents/audiobooks \
    data/usenet/tv \
    data/usenet/movies \
    data/usenet/audiobooks \
    data/media/tv \
    data/media/movies \

# this guy finally solved it for me
# https://medium.com/@Pooch/containerized-media-server-setup-with-podman-3727727c8c5f
podman unshare chown -R "$puid:$pgid" config
podman unshare chown -R "$puid:$pgid" data

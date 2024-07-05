#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
(docker && docker compose version) || (bash ./docker.sh && exit 0)
if [[ "$EUID" = 0 ]]; then
    exit 1
fi
config="homeserv"
installdir="~/$config"
composer="$installdir/docker-compose.yaml"
env="$installdir/.env"
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
mediadir="$installdir/media"
configdir="$installdir/config"
dir "$installdir" || mkdir -p "$installdir"
dir "$mediadir" || mkdir -p "$mediadir"
cp "$config.docker-compose.yaml" "$composer"
cp "$config.env" "$env"
sed -i -e "s|<puid>|$puid|g" "$env" \
 -e "s|<pgid>|$pgid|g" "$env" \
 -e "s|<media>|$mediadir|g" "$env" \
 -e "s|<config>|$configdir|g" "$env" \
 -e "s|<name>|$config|g" command \
 -e "s|<composer>|$composer|g" command
docker compose -f "$composer" up -d
sudo cp command "/usr/local/bin/$config" && sudo chmod +x "/usr/local/bin/$config"
sudo chown -R "$puid":"$pgid" "$mediadir"
sudo chown -R "$puid":"$pgid" "$installdir"
dir "$configdir" || sudo mkdir -p "$configdir"
sudo chown -R "$puid":"$pgid" "$configdir"
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
installname="homeserv"
sudo mkdir -p "~/$installname"
sudo chown -R $USER:$USER "~/$installname"
( docker &> /dev/null && docker compose version &> /dev/null ) || bash ./docker.sh
if [[ "$EUID" = 0 ]]; then
    exit 1
fi
[ ! -d "~/$installname" ] && mkdir -p "~/$installname"
[ ! -w "~/$installname" ] || [ ! -r "~/$installname" ]
installcomposer="~/$installname/docker-compose.yaml"
installenv="~/$installname/.env"
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
installmedia="~/$installname/media"
[ ! -d "$installmedia" ] && mkdir -p "$installmedia"
cp "$installname.docker-compose.yaml" "$installcomposer"
cp "$installname.env" "$installenv"
sed -i -e "s|<puid>|$puid|g" "$installenv" -e "s|<pgid>|$pgid|g" "$installenv" -e "s|<media>|$installmedia|g" "$installenv" -e "s|<config>|~/$installname/config|g" "$installenv"
sed -i -e "s|<name>|$installname|g" command
docker compose -f "$installcomposer" up -d
sudo cp command "/usr/local/bin~/$installname" && sudo chmod +x "/usr/local/bin~/$installname"
sudo chown -R "$puid":"$pgid" "$installmedia"
sudo chown -R "$puid":"$pgid" "~/$installname"
[ ! -d "~/$installname/config" ] && sudo mkdir -p "~/$installname/config"
sudo chown -R "$puid":"$pgid" "~/$installname/config"
exit 0
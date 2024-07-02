#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
installname="homeserv"
sudo mkdir -p "~/$installname" || exit 1
sudo chown -R $USER:$USER "~/$installname" || exit 2
(docker &> /dev/null && docker compose version &> /dev/null) || bash ./docker.sh
if [[ "$EUID" = 0 ]]; then
    exit 3
fi
([ ! -d "~/$installname" ] && mkdir -p "~/$installname") || exit 4
([ ! -w "~/$installname" ] || [ ! -r "~/$installname" ]) || exit 5
installcomposer="~/$installname/docker-compose.yaml"
installenv="~/$installname/.env"
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
installmedia="~/$installname/media"
([ ! -d "$installmedia" ] && mkdir -p "$installmedia") || exit 6
cp "$installname.docker-compose.yaml" "$installcomposer" || exit 7
cp "$installname.env" "$installenv" || exit 8
sed -i -e "s|<puid>|$puid|g" "$installenv" -e "s|<pgid>|$pgid|g" "$installenv" -e "s|<media>|$installmedia|g" "$installenv" -e "s|<config>|~/$installname/config|g" "$installenv" || exit 9
sed -i -e "s|<name>|$installname|g" command || exit 10
docker compose -f "$installcomposer" up -d || exit 11
(sudo cp command "/usr/local/bin~/$installname" && sudo chmod +x "/usr/local/bin~/$installname") || exit 12
sudo chown -R "$puid":"$pgid" "$installmedia" || exit 13
sudo chown -R "$puid":"$pgid" "~/$installname" || exit 14
([ ! -d "~/$installname/config" ] && sudo mkdir -p "~/$installname/config") || exit 15
sudo chown -R "$puid":"$pgid" "~/$installname/config" || exit 16
exit 0
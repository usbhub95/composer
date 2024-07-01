#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
sudo mkdir -p /opt/yams
sudo chown -R $USER:$USER /opt/yams
if command -v docker &> /dev/null; then
    if ![docker compose version &> /dev/null]; then
        bash ./docker.sh
    fi
else
    bash ./docker.sh
fi
if [[ "$EUID" = 0 ]]; then
    exit 0
fi
# edit this to suit needs
installname="homeserv"
if [ ! -d "/$installname" ]; then
    if mkdir -p "/$installname"; then
        echo
    else
        exit 1
    fi
fi
if [ ! -w "/$installname" ] || [ ! -r "/$installname" ]; then
    exit 2
fi
installcomposer="/$installname/docker-compose.yaml"
installenv="/$installname/.env"
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
installmedia="/$installname/media"
if [ ! -d "$installmedia" ]; then
    if mkdir -p "$installmedia"; then
        echo
    else
        exit 3
    fi
fi
if cp "$installname.docker-compose.yaml" "$installcomposer"; then
    echo
else
    exit 4
fi
if cp "$installname.env" "$installenv"; then
    echo
else
    exit 5
fi
sed -i -e "s|<puid>|$puid|g" "$installenv" \
 -e "s|<pgid>|$pgid|g" "$installenv" \
 -e "s|<media>|$installmedia|g" "$installenv" \
 -e "s|<config>|/$installname/config|g" "$installenv"
sed -i -e "s|<name>|$installname|g" command
docker compose -f "$installcomposer" up -d
if  ![sudo cp command "/usr/local/bin/$installname" && sudo chmod +x "/usr/local/bin/$installname"]; then
    exit 6
fi
if ![sudo chown -R "$puid":"$pgid" "$installmedia"]; then
    exit 7
fi
if ![sudo chown -R "$puid":"$pgid" "/$installname"]; then
    exit 8
fi
if ![[ -d "/$installname/config" ]]; then
    if ![sudo mkdir -p "/$installname/config"]; then
        exit 9
    fi
fi
if ![sudo chown -R "$puid":"$pgid" "/$installname/config"]; then
    exit 10
fi
exit 11
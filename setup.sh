#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ "$EUID" = 0 ]]; then
    echo "do not run from sudo, exiting..."
	exit 255
fi

echo "setting up git..."
sudo apt install -y git

if command -v docker &> /dev/null; then
	echo
else
	echo "setting up docker..."
	bash ./setup-docker.sh
fi

echo "setting up..."
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
read -p "input config to set up: " config
config=${config}
group-root="/$config"
group-install="$group-root/install"
group-config="$group-config"
group-media="$group-root/media"
group-env="./$config/.env"
group-composer="./$config/docker-compose.yaml"

echo "setting up \"$group-install\"..."
sudo mkdir -p "$group-install"	
sudo chown -R $USER:$USER "$group-install"
sudo chown -R "$puid":"$pgid" "$group-install"

echo "setting up \"$group-media\"..."
sudo mkdir -p "$group-media"
sudo chown -R $USER:$USER "$group-media"
sudo chown -R "$puid":"$pgid" "$group-media"

echo "setting up \"$group-config\"..."
sudo mkdir -p "$group-config"
sudo chown -R $USER:$USER "$group-config"
sudo chown -R "$puid":"$pgid" "$group-config"

echo "setting up \"$group-composer\" as \"$group-install/docker-compose.yaml\"..."
cp "$group-composer" "$group-install/docker-compose.yaml"
echo "setting up \"$group-env\" as \"$group-install/.env\"..."
cp "$group-env" "$group-install/.env"

echo "setting up .env file..."
sudo sed -i -e "s|<puid>|$puid|g" "$group-install/.env" \
 -e "s|<pgid>|$pgid|g" "$group-install/.env" \
 -e "s|<media>|$group-media|g" "$group-install/.env" \
 -e "s|<installed>|$group-install|g" "$group-install/.env"
 
echo "setting up $config command..."
sudo sed -i -e "s|<dockerfile>|$group-install/docker-compose.yaml|g" command \
 -e "s|<installed>|$group-install|g"  \
 -e "s|<name>|$config|g"
sudo cp command "/usr/local/bin/$config"
sudo chmod +x "/usr/local/bin/$config"

echo "setting up docker compose..."
docker compose -f "$group-install/docker-compose.yaml" up -d

echo "done!"
exit 0
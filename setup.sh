#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
if [[ "$EUID" = 0 ]]; then
    echo "do not run from sudo, exiting..."
	exit 255
fi
echo "setting up git..."
sudo apt install -y git
if [command -v docker &> /dev/null] && [docker compose version &> /dev/null]; then
	echo "skipping docker..."
else
	echo "setting up docker..."
	bash ./setup-docker.sh
fi
read -p "input config to set up: " config
config=${config}
echo "setting up .env file..."
sudo sed -i -e "s|<puid>|$puid|g" "$config/.env" \
 -e "s|<pgid>|$pgid|g" "$config/.env" \
 -e "s|<media>|/$config/media|g" "$config/.env" \
 -e "s|<installed>|/$config/install|g" "$config/.env"
echo "installing..."
cp -R "$config/" "/$config"
install="/$config/install"
sudo chown -R $USER:$USER "/$config"
sudo chown -R "$puid":"$pgid" "/$config"
echo "setting up $config command..."
sudo sed -i -e "s|<composer>|$install/docker-compose.yaml|g" command \
 -e "s|<name>|$config|g" command
sudo cp command "/usr/local/bin/$config"
sudo chmod +x "/usr/local/bin/$config"
echo "setting up docker compose..."
docker compose -f "$install/docker-compose.yaml" up -d
echo "done!"
exit 0
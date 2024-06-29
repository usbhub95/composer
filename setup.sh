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
if command -v docker &> /dev/null; then
	echo
else
	echo "setting up docker..."
	bash ./setup-docker.sh
fi
read -p "input config to set up: " config
config=${config}
echo "setting up installation..."
sudo cp -R "$config/" "/$config"
install="/$config/install"
sudo chown -R $USER:$USER "/$config"
sudo chown -R "$puid":"$pgid" "/$config"
echo "setting up .env file..."
sudo sed -i -e "s|<puid>|$puid|g" "$install/.env" \
 -e "s|<pgid>|$pgid|g" "$install/.env" \
 -e "s|<media>|/$config/media|g" "$install/.env" \
 -e "s|<installed>|$install|g" "$install/.env"
echo "setting up $config command..."
sudo sed -i -e "s|<composer>|$install/docker-compose.yaml|g" command \
 -e "s|<name>|$config|g"
sudo cp command "/usr/local/bin/$config"
sudo chmod +x "/usr/local/bin/$config"
echo "setting up docker compose..."
docker compose -f "$install/docker-compose.yaml" up -d
echo "done!"
exit 0
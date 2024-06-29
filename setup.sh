#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ "$EUID" = 0 ]]; then
    echo "do not run from sudo, exiting..."
	exit 255
fi

echo "setting up git..."
sudo apt install -y git

echo "setting up docker..."
bash ./setup-docker.sh

echo "setting up..."
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
read -p "input config to set up: " filename
filename=${filename}
media_directory="/$filename/media"
install_directory="/$filename/install"
env_file="/$install_directory/.env"

echo "setting up \"$install_directory\"..."
sudo mkdir -p "$install_directory"	
sudo chown -R $USER:$USER "$install_directory"
sudo chown -R "$puid":"$pgid" "$install_directory"

echo "setting up \"$media_directory\"..."
sudo mkdir -p "$media_directory"
sudo chown -R $USER:$USER "$media_directory"
sudo chown -R "$puid":"$pgid" "$media_directory"

echo "setting up \"$install_directory/config\"..."
sudo mkdir -p "$install_directory/config"
sudo chown -R $USER:$USER "$install_directory/config"
sudo chown -R "$puid":"$pgid" "$install_directory/config"

echo "setting up \"$filename/docker-compose.yaml\" as \"$install_directory/docker-compose.yaml\"..."
cp "$filename/docker-compose.yaml" "$install_directory/docker-compose.yaml"
echo "setting up \"$filename/.env\" as \"$install_directory/.env\"..."
cp "$filename/.env" "$env_file"

echo "setting up .env file..."
sed -i -e "s|<your_PUID>|$puid|g" "$env_file" \
 -e "s|<your_PGID>|$pgid|g" "$env_file" \
 -e "s|<media_directory>|$media_directory|g" "$env_file" \
 -e "s|<install_directory>|$install_directory|g" "$env_file"
 
echo "setting up $filename command..."
sed -i -e "s|<filename>|$install_directory/docker-compose.yaml|g" command \
 -e "s|<install_directory>|$install_directory|g"  \
 -e "s|<command_name>|$filename|g"
sudo cp command "/usr/local/bin/$filename"
sudo chmod +x "/usr/local/bin/$filename"

echo "setting up docker compose..."
docker compose -f "$install_directory/docker-compose.yaml" up -d

echo "done!"
exit 0
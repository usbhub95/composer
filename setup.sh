#!/bin/bash
set -euo pipefail

if [[ "$EUID" = 0 ]]; then
    echo "do not run from sudo!"
	exit 255
fi

echo "checking dependencies..."
if [ ! command -v git &> /dev/null ]; then
	echo "git not found, installing..."
	sudo apt install git
fi
if command -v docker &> /dev/null; then
	if [ !docker compose version &> /dev/null ]; then
		echo "docker compose not found, installing..."
		bash ./setup-docker.sh
	fi
else
	echo "docker not found, installing..."
	bash ./setup-docker.sh
fi

echo "getting ready..."
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
read -p "input config to set up: " filename
filename=${filename}
media_directory="$filename/media"
install_directory="$filename/install/"
env_file="$install_directory/.env"

echo "checking directories..."
if [ ! -d "$install_directory" ]; then
    echo "\"$install_directory\" not found, creating..."
    sudo mkdir -p "$install_directory"
	sudo chown -R $USER:$USER "$install_directory"
fi
if [ ! -w "$install_directory" ] || [ ! -r "$install_directory" ]; then
	echo "\"$install_directory\" found with incorrect perms, fixing..."
	sudo chown -R $USER:$USER "$install_directory"
fi
echo "\"$install_directory\" found!"
if [ ! -d "$media_directory" ]; then
    echo "\"$media_directory\" not found, creating..."
    sudo mkdir -p "$media_directory"
	sudo chown -R $USER:$USER "$media_directory"
fi
if [ ! -w "$media_directory" ] || [ ! -r "$media_directory" ]; then
	echo "\"$media_directory\" found with incorrect perms, fixing..."
	sudo chown -R $USER:$USER "$media_directory"
fi
echo "\"$media_directory\" found!"

echo "copying files..."
echo "copying \"docker-compose.$filename.yaml\" to \"$install_directory/docker-compose.yaml\"..."
cp "docker-compose.$filename.yaml" "$install_directory/docker-compose.yaml"
echo "copying \"$filename.env\" to \"$install_directory/.env\"..."
cp "$filename.env" "$env_file"

echo "udpate .env file..."
sed -i -e "s|<your_PUID>|$puid|g" "$env_file" \
 -e "s|<your_PGID>|$pgid|g" "$env_file" \
 -e "s|<media_directory>|$media_directory|g" "$env_file" \
 -e "s|<media_service>|$media_service|g" "$env_file" \
 -e "s|<media_service>|$media_service|g" "$filename"
 
echo "running docker compose..."
docker compose -f "$install_directory/docker-compose.yaml" up -d

echo "done!"
exit 0
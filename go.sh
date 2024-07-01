#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
if [[ "$EUID" = 0 ]]; then
    echo "do not sudo this!"
	exit 255
fi
if command -v git &> /dev/null; then
	echo "git found..."
else
	echo "installing git..."
	sudo apt install -y git
fi
function getdocker {
	version=$(cat /etc/issue.net | awk '{print tolower($1)}')
	sudo apt update
	sudo apt install -y ca-certificates curl gnupg lsb-release
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/$version/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$version $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
	sudo usermod -aG docker $USER
	sudo su $USER --group="docker" --session-command="bash go.sh"
	exit 2
}
if command -v docker &> /dev/null; then
	echo "docker found..."
	if docker compose version &> /dev/null; then
		echo "docker compose found..."
	else
		echo "installing docker compose..."
		getdocker
		exit 1
	fi
else
	echo "installing docker..."
	getdocker
	exit 1
fi
read -p "config name? [homeserv]" config
config=${config:-"homeserv"}
installroot="/$config"
if [ ! -d "$installroot" ]; then
    echo "creating \"$installroot\"..."
    if sudo mkdir -p "$installroot"; then
        echo "\"$installroot\" created..."
    else
        echo "\"$installroot\" NOT created!"
		exit 255
    fi
fi
if [ ! -w "$installroot" ] || [ ! -r "$installroot" ]; then
	echo "bad perms on \"$installroot\", fixing..."
    sudo chown -R $USER:$USER $installroot
fi
installcomposer="$installroot/docker-compose.yaml"
installenv="$installroot/.env"
puid=$(id -u "$USER");
pgid=$(id -g "$USER");
installmedia="$installroot/media"
if [ ! -d "$installmedia" ]; then
    echo "creating \"$installmedia\"..."
    if mkdir -p "$installmedia"; then
        echo "\"$installmedia\" created..."
    else
        echo "\"$installmedia\" NOT created!"
		exit 255
    fi
fi
installfiles=(
    "$config.docker-compose.yaml:$installcomposer"
    "$config.env:$installenv"
)
for file in "${installfiles[@]}"; do
    source="${file%%:*}"
    dest="${file##*:}"
    echo "installing \"$source\"..."
    if cp "$source" "$dest"; then
        echo "\"$source\" installed..."
    else
        echo "\"$source\" NOT installed!"
		exit 255
    fi
done
sed -i -e "s|<puid>|$puid|g" "$installenv" \
 -e "s|<pgid>|$pgid|g" "$installenv" \
 -e "s|<media>|$installmedia|g" "$installenv" \
 -e "s|<installed>|$installroot|g" "$installenv" 
sed -i -e "s|<name>|$config|g" command
docker compose -f "$installcomposer" up -d
if sudo cp command "/usr/local/bin/$config" && sudo chmod +x "/usr/local/bin/$config"; then
    echo "$config command installed..."
else
    echo "$config command NOT installed!"
	exit 255
fi
if sudo chown -R "$puid":"$pgid" "$installmedia"; then
    echo "\"$installmedia\" permissions set..."
else
    echo "\"$installmedia\" permissions NOT set!"
	exit 255
fi
if sudo chown -R "$puid":"$pgid" "$installroot"; then
    echo "\"$installroot\" permissions set..."
else
    echo "\"$installroot\" permissions NOT set!"
	exit 255
fi
if [[ -d "$installroot/config" ]]; then
    echo "\"$installroot/config\" found..."
else
    if sudo mkdir -p "$installroot/config"; then
        echo "\"$installroot/config\" installed..."
    else
        echo "\"$installroot/config\" installed..."
		exit 255
    fi
fi
if sudo chown -R "$puid":"$pgid" "$installroot/config"; then
    echo "\"$installroot/config\" permissions set..."
else
    echo "\"$installroot/config\" permissions set..."
	exit 255
fi
echo "all done!"
exit 0
# Copyright (C) 2024 Cooper Lockrey

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
(docker && docker compose version) || (bash ./docker.sh && exit 0)
if [[ "$EUID" = 0 ]]; then
    exit 1
fi
config="homeserv"
installdir="/home/$USER/$config"
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
exit 0
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
name="<name>"
composer="<composer>"
param=${1:-"--help"}
case $param in
    --help)
        echo "$name - docker group"
        echo "Usage: $name [--help|restart|stop|start|disable]"
        echo "options:"
        echo "--help     displays this help message"
        echo "restart    restarts all $name containers"
        echo "stop       stops all $name containers"
        echo "start      starts and enables all $name containers and services"
        echo "disable    stops and disables all $name containers and services"
        exit 0
        ;;
    restart)
        echo "restarting $name containers"
        docker compose -f $composer stop && docker compose -f up -d
        echo "$name containers are starting, this may take a while..."
        exit 0
        ;;
    stop)
        echo "stopping $name containers"
        docker compose -f $composer stop
        echo "$name containers have been stopped!"
        exit 0
        ;;
    start)
        echo "starting and enabling $name containers and services..."
        docker compose -f $composer up -d
        echo "$name services have been enabled!"
        echo "$name containers are starting, this may take a while..."
        exit 0
        ;;
    disable)
        echo "stopping and disabling $name containers and services..."
        docker compose -f $composer down
        echo "$name services have been disabled!"
        echo "$name containers have been stopped!"
        exit 0
        ;;
esac
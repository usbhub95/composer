#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
group="docker compose -f <composer>"
name="<name>"
param=${1:-"--help"}
case $param in
	--help)
		echo "$name - docker group"
		echo "Usage: $name [--help|restart|stop|start|disable]"
		echo "options:"
		echo "--help     displays this help message"
		echo "restart    restarts all $name containers"
		echo "stop       stops all $name containers"
		echo "start      starts and permanently enables all $name containers and services"
		echo "disable    stop and permanently disable all $name containers and services"
		exit 0
		;;
	restart)
		echo "restarting $name containers"
		$group stop && $group up -d
		echo "$name containers are starting, this may take a while..."
		exit 0
		;;
	stop)
		echo "stopping $name containers"
		$group stop
		echo "$name containers have been stopped!"
		exit 0
		;;
	start)
		echo "starting and permanently enabling $name containers and services..."
		$group up -d
		echo "$name services have been permanently enabled!"
		echo "$name containers are starting, this may take a while..."
		exit 0
		;;
	disable)
		echo "stopping and permanently disabling $name containers and services..."
		$group down
		echo "$name services have been permanently disabled!"
		echo "$name containers have been stopped!"
		exit 0
		;;
esac
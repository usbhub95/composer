# composer
My docker-compose scripts.\
install.sh is intended for use on a fresh debian system with nothing but standard tools and ssh packages installed.\
homeserv is a docker group with accompanying group management command\
the group stack is minimal (what i will use) and consists of:\
- qbittorrent
- lidarr
- readarr
- jackett
- flaresolverr
- watchtower
the point is its super easily modifyable, basically with a little knowledge you just drop in your docker compose file and any fresh debian system is set up through ssh\
still not really sure what i should call this\
## usage
its pretty simple to figure out how to adapt this to your preferences\
quick setup (my config)\
```sh
sudo apt install git
sudo mkdir -p "~/homeserv"
sudo chown -R $USER:$USER "~/homeserv"
git clone --depth=1 https://github.com/usbhub95/composer.git /tmp/composer
cd /tmp/composer
bash install.sh
```
just copy paste into your ssh terminal, and everything will be set up\
you may use the new command to manage the network simply\
```sh
user@homeserv:~$ homeserv
homeserv - docker group
Usage: homeserv [--help|restart|stop|start|disable]
options:
--help     displays this help message
restart    restarts all homeserv containers
stop       stops all homeserv containers
start      starts and enables all homeserv containers and services
disable    stops and disables all homeserv containers and services
user@homeserv:~$
```
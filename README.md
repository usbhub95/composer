# composer
 My docker-compose scripts.
go.sh is intended for use on a fresh debian system with nothing but standard tools and ssh packages installed.
homeserv is a docker group with accompanying group management command
the group stack is minimal (what i will use) and consists of:
- qbittorrent
- lidarr
- readarr
- jackett
- flaresolverr
- watchtower
the point is its super easily modifyable, basically with a little knowledge you just drop in your docker compose file and any fresh debian system is set up through ssh
still not really sure what i should call this
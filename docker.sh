#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
version=$(cat /etc/issue.net | awk '{print tolower($1)}')
sudo apt update || exit 1
sudo apt install -y ca-certificates curl gnupg lsb-release || exit 2
sudo mkdir -p /etc/apt/keyrings || exit 3
(curl -fsSL https://download.docker.com/linux/$version/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg) || exit 4
(echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$version $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null) || exit 5
sudo apt update || exit 6
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || exit 7
sudo usermod -aG docker $USER || exit 8
sudo su $USER --session-command "bash install.sh" || exit 9
exit 0
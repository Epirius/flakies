#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git home-manager
username=$(whoami)

# NB: This script should be used on a clean install of nixos
# where not even the git repo has been cloned yet.

# Check if sudo
if [ "$EUID" -eq 0 ]; then
	echo "Please do not run this script as root."
	exit 1
fi


# Cloning the repo
cd /home/$username
git clone https://github.com/Epirius/flakies.git
cd flakies


# Updating hardware config
sudo rm ./nixos/hardware-configuration.nix
sudo cp /etc/nixos/hardware-configuration.nix ./nixos/

# Bootstrapping system
export NIX_CONFIG="experimental-features = nix-command flakes"
rm /home/$username/.mozilla/firefox/profiles.ini
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#$username@nixos


rustup default stable
nix-collect-garbage -d

exit 0




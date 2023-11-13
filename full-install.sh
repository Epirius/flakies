#!/usr/bin/env nix-shell

# NB: This script should be used on a clean install of nixos
# where not even the git repo has been cloned yet.

# Check if sudo
if [ "$EUID" -ne 0 ]; then
	echo "This script requires sudo privileges. Please run it with sudo."
	exit 1
fi

#!nix-shell -i bash -p git home-manager

# Cloning the repo
cd ~
git clone https://github.com/Epirius/flakies.git
cd flakies

# Updating hardware config
rm ./nixos/hardware-configuration.nix
sudo cp /etc/nixos/hardware-configuration.nix ./nixos/

# Bootstrapping system
export NIX_CONFIG="experimental-features = nix-command flakes"
rm /home/felix/.mozilla/firefox/profiles.ini
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#felix@nixos

rustup default stable
nix-collect-garbage -d
exit 0




#!/usr/bin/env nix-shell

# Check if sudo
if [ "$EUID" -ne 0 ]; then
	echo "This script requires sudo privileges. Please run it with sudo."
	exit 1
fi

#!nix-shell -i bash -p home-manager

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




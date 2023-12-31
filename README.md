using this article to set up my config:
https://cola-gang.industries/nixos-for-the-confused-part-i

```
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#felix@nixos
```

## temp install to shell
```
nix shell nixpkgs\#neofetch
```

# installation instructions
## install via script
start from a clean install of nixos.
```
download the script from https://github.com/Epirius/flakies/blob/main/full-install.sh

chmod +x full-install.sh
./full-install.sh
```

## manual install
1. Starting with a fresh nixos install, we need to install git and neovim:
```
cd /etc/nixos
sudo nano configuration.nix
# add git and neovim
sudo nixos-rebuild switch
 ```
2. Clone this repo and add hardware file:
```
cd ~
git clone https://github.com/Epirius/flakies.git
cd flakies/nixos/
rm hardware-configuration.nix
sudo cp /etc/nixos/hardware-configuration.nix .
cd ~/flakies
```
3. Bootstrap system:
```
export NIX_CONFIG="experimental-features = nix-command flakes"
rm /home/felix/.mozilla/firefox/profiles.ini
nix shell nixpkgs#home-manager
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#felix@nixos

nix-collect-garbage -d
```
4. you can now safely reboot

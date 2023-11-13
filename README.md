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
NB: SCRIPT DOES NOT CURRENTLY WORK CORRECTLY
start from a clean install of nixos.
download and run full-install.sh (without cloning the repo)

## manual install
1. Starting with a fresh nixos install, we need to install git and neovim:
```
# TODO: this can be changed to a temp shell
cd /etc/nixos
sudo nano configuration.nix
# add git and neovim
sudo nixos-rebuild switch
 ```
2. Clone this repo and add hardware file:
```
cd ~
git clone https://github.com/Epirius/flakies.git
```
NB: SCRIPT DOES NOT CURRENTLY WORK CORRECTLY
You can run ./install.sh at this point, or continue manually
```
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

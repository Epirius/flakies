{
 description = "My Flakie"; #You can change this to whatever

 inputs = {
   # Nixpkgs
   nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

   # Home manager
   home-manager = {
     url = "github:nix-community/home-manager";
     inputs.nixpkgs.follows = "nixpkgs";
   };

   # NUR firefox-addons
   firefox-addons = {
     url = "gitlab:rycee/nur-expressions/?dir=pkgs/firefox-addons";
     inputs.nixpkgs.follows = "nixpkgs";
   };

   # Hardware
   hardware.url = "github:nixos/nixos-hardware";

   # Xmonad modules
   xmonad-contexts = {
     url = "github:Procrat/xmonad-contexts";
     flake = false;
   };
 };

 outputs = { self, nixpkgs, home-manager, ... }@inputs: {
   # NixOS configuration entrypoint
   # Available through 'nixos-rebuild --flake .#your-hostname'

   nixosConfigurations = {
     nixos = nixpkgs.lib.nixosSystem {
       specialArgs = { inherit inputs; }; # Pass flake inputs to our config
       # > Our main nixos configuration file <
       modules = [ 
         ./nixos/configuration.nix
       ];
     };
   };

   # home-manager configuration entrypoint
   # Available through 'home-manager --flake .#your-username@your-hostname'
   homeConfigurations = {
     "felix@nixos" = home-manager.lib.homeManagerConfiguration {
       pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
       extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
       # > Our main home-manager configuration file <
       modules = [ 
           ./home-manager/home.nix 
           ];
     };
   };
 };
}

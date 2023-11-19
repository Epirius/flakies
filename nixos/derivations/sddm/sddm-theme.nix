{ pkgs }:

let
    imgLink = "https://github.com/Epirius/flakies/blob/main/home-manager/backgrounds/journey.jpg";
    image = pkgs.fetchurl {
        url = imgLink;
        sha256 = "";
    };
in
pkgs.stdenv.mkDerivation {
    name = "sddm-theme-delicious";
    src = pkgs.fetchFromGitHub {
        owner = "stuomas";
        repo = "delicious-sddm-theme";
        rev = "fc98a56db6a61521cb2c55f2c50416f01f565ef7";
        sha256 = "085n7663p0bz6jl516z7gvkc09m2rr33cygpl3n3fnyg3ins7msw";
    };
    installPhase = ''
        mkdir -p $out
        cp -R ./* $out/
        cd $out/background/
        cp -r ${image} $out/background/bg.jpg
        cd $out/
        rm theme.conf
        cp $src/theme.conf $out/theme.conf
        
    '';
}
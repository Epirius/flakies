{ config, pkgs, inputs, lib, ... }:

{
  home.username = "felix";
  home.homeDirectory = "/home/felix";
  home.stateVersion = "22.11";
  nixpkgs = {
      config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    jq
    tree
    neofetch
    eza
    google-chrome
    chromium
  ];

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    firefox = {
      enable = true;
      profiles.default = {
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
	  ublock-origin 
	];

	bookmarks = [
	  {
            name = "YouTube";
	    tags = [ "videos" ];
	    keyword = "videos";
	    url = "https://www.youtube.com/";
	  }
	];

	settings = {
	  "browser.download.panel.shown" = true;
	  "identity.fxaccounts.enable" = false;
	  "signon.rememberSignons" = false;
	};

	search.engines = {
	  "Nix Packages" = {
	    urls = [{

	      template = "https://search.nixos.org/packages";
	      params = [
	        { name = "type"; value = "packages"; }
	        { name = "query"; value = "{searchTerms}"; }
	      ];
	    }];
	    definedAliases = ["np"];
	  };

	  "Twitch" = {
	    urls = [{
	      template = "https://www.twitch.tv/{searchTerms}";
	    }];
	    definedAliases = ["t"];
          };

	  "Reddit" = {
	    urls = [{
	      template = "https://www.reddit.com/r/{searchTerms}";
	    }];
	    definedAliases = ["r"];
	  };
	};

	search.force = true;
      };
    };
    
    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      ];
    };

    zsh = {
      enable = true;
    };

    zsh.oh-my-zsh= {
      enable = true;
      plugins = ["git" "python" "docker" "fzf"];
      theme = "dpoggi";
    };

    git = {
      enable = true;
      userName = "Felix Kaasa";
      userEmail = "mrKaasa@protonmail.com";
    };

  };

   home.sessionVariables = {
    EDITOR="nvim";
  };
  home.shellAliases = {
    l = "eza";
    ls = "eza";
    cat = "bat";
  };

}

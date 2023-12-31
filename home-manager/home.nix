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
  home.sessionVariables = {
    EDITOR="nvim";
  };
  home.shellAliases = {
    l = "eza -la";
    ls = "eza";
    cat = "bat";
    home-switch = "home-manager switch --flake .#felix@nixos";
    nixos-switch = "nixos rebuild switch --flake .#nixos";
    c = "clear";
    reload = "source ~/.zshrc";
    cg = "cargo";
  };
  home.file = {
    ".config/../.local/share/konsole/Breeze.colorscheme" = {
      source = ./konsole/Breeze.colorscheme;
    };
    ".config/../.local/share/konsole/Profile\ 1.profile" = {
      source = ./konsole/Profile1.profile;
    };
    ".config/../.p10k.zsh" = {
      source = ./konsole/.p10k.zsh;
    };
    ".config/../.xmonad/startup.sh" = {
      source = ./xmonad/startup.sh;
    };
  };
  


    # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    authy
    bat
    chromium
    dunst
    eza
    fd
    fzf
    gh
    google-chrome
    helix
    httpie
    jetbrains.idea-ultimate
    jetbrains.rust-rover
    jq
    nitrogen
        obsidian
    ripgrep
    rofi
    spotify
    tealdeer
    tree
    vlc
    vscode
    z-lua
    zellij
    zsh-powerlevel10k
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
        #enhancer-for-youtube
        #grammarly
        facebook-container
        proton-pass
        pushbullet
        reddit-comment-collapser
        reddit-enhancement-suite
        sponsorblock
        ublock-origin
        videospeed
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
      enableAutosuggestions = true;
      initExtra = "
        bindkey '^H' backward-kill-word \n
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      ";
      syntaxHighlighting.enable = true;

      
      zplug = {
        enable = true;
        plugins = [
          {name = "MichaelAquilina/zsh-you-should-use"; }
          {
            name = "romkatv/powerlevel10K";
            tags = [ "as:theme" "depth:1" ];
          }
        ];
      };

      oh-my-zsh= {
        enable = true;
        plugins = ["git" "python" "docker" "fzf" "web-search" ];
        theme = "dpoggi";
      };
    };

    z-lua = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "Felix Kaasa";
      userEmail = "mrKaasa@protonmail.com";
      aliases = {
        p = "push";
	      cm = "commit";
      };
    };

    vscode = {
      enable = true;
      enableExtensionUpdateCheck = true;
      extensions = with pkgs.vscode-extensions; [
        # see: https://search.nixos.org/packages?channel=23.05&from=0&size=50&sort=relevance&type=packages&query=vscode-extensions
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        bradlc.vscode-tailwindcss
        rust-lang.rust-analyzer
        asvetliakov.vscode-neovim
        tomoki1207.pdf
        bbenoist.nix
      ];
    };
    
    rofi = {
      enable = true;
      theme = "${pkgs.rofi}/share/rofi/themes/Monokai.rasi";
    };

  };

  services = {
    dunst = {
      enable = true;

    };
  };


}

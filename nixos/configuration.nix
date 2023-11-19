# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };
  
  services = {

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      
      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";
      xkbOptions = "eurosign:e caps:escape";
  
      # Enable the KDE Plasma Desktop Environment.
      displayManager = {
        sddm = {
          enable = true;
          #theme = "${import ./derivations/sddm/sddm-theme.nix {inherit pkgs; }}";
        };
        setupCommands = "nitrogen --set-auto ./../home-manager/backgrounds/journey.jpg";
        sessionCommands = "killall picom";
        defaultSession = "none+xmonad";
      };
      desktopManager.plasma5.enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        enableConfiguredRecompile = true;
  
        config = ./../home-manager/xmonad/xmonad.hs;
        extraPackages =  haskellPackages: [
	        haskellPackages.xmobar
        ];

        ghcArgs = [
          "-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
          "-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
          "-i${inputs.xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
        ];
  
      };
  
      # Configure libinput
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.felix = {
    isNormalUser = true;
    description = "felix";
    hashedPassword = "$y$j9T$.MRwT6Xn6Ero8.XavKxX..$fDymN.WLA8PGkJuFdjRm87D2kjooIwFoQe/JqUEyBmC";
    extraGroups = [ "networkmanager" "wheel" "video" "lp" "scanner" "docker" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cabal-install
    cmake
    coreutils
    docker
    docker-compose
    gcc
    ghc
    git
    gnupg
    httpie
    htop
    jetbrains.jdk
    killall
    libfido2
    libsForQt5.spectacle
    libsForQt5.qt5.qtquickcontrols2   
    libsForQt5.qt5.qtgraphicaleffects
    neofetch
    neovim 
    picom
    python3
    rustup
    slock
    stack
    wget
    zip
  ];

  # Install fonts
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
    font-awesome_5
    liberation_ttf
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    powerline
    source-code-pro
  ];

  # Enable picom compositor
  services.picom = {
    enable = false;
    shadow = false;
    vSync = true;
  };

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "monthly";
      flags = [ "--all" ];
    };
  };
  
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  systemd.services.upower.enable = true;

  # xps 13 pluss webcam
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  # Enable lock screen
  programs.slock.enable = true;
  

  # Enable Flakes
  nix.package = pkgs.nixFlakes;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

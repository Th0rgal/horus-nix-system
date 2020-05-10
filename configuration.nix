{ config, pkgs, ... }:

{

  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    #extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "horus";
    networkmanager.enable = true;
    #nameservers = [ "1.1.1.1" "9.9.9.9" ];
    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 3000 8080 ];
    };
  };

  # tty layout
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };
  i18n.defaultLocale = "fr_FR.UTF-8";

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    wget vim git pv nodejs brightnessctl system-config-printer #exfat
  ];

  nixpkgs.overlays = [
    (import ./nix-nerd-fonts-overlay/default.nix)
  ];

  fonts = {
    enableDefaultFonts = true; 
    enableFontDir = true;
    fonts = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
	      corefonts
        dejavu_fonts
        source-code-pro
        ubuntu_font_family
    ];
  };


  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "fr";
      xkbOptions = "eurosign:e";

      # Enable touchpad support.
      libinput.enable = true;

      # Enable lightdm
      displayManager.lightdm.enable = true;
      desktopManager.xterm.enable = true;
    };   

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    };

    # Enable ipfs
    ipfs.enable = false;

    # Optimize battery
    tlp.enable = true;

    # Enable bluetooth service
    blueman.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  hardware.ledger.enable = true;

  programs = {
    zsh = {
      enable = true;
      interactiveShellInit = ''
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
        path+=('~/.npm-global/bin')
        export PATH

        # oh-my-zsh options
        ZSH_THEME="agnoster"
        plugins=(git)

        source $ZSH/oh-my-zsh.sh
      '';
     promptInit = ""; # Clear this to avoid conflict with omz
    };
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.thomas = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "video" "plugdev" ];
    };
  };

  system.stateVersion = "20.03";
  nixpkgs.config.allowUnfree = true;

}

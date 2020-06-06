{ pkgs, ... }: {
 environment.systemPackages = with pkgs; [
    wget vim git pv nodejs brightnessctl system-config-printer ccid
  ];


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
}
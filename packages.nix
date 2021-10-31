{ pkgs, ... }: {

  environment = {
    systemPackages = with pkgs; [
      neovim
      wget
      git
      pv
      nodejs
      brightnessctl
      system-config-printer
      ccid
      libimobiledevice
    ];
    variables.EDITOR = "nvim";
  };

  services.usbmuxd.enable = true;

  imports = [ ./modules/howdy.nix ./modules/ir_toggle.nix ];

  nixpkgs = {

    overlays = [
      (self: super: {
        neovim = super.neovim.override {
          viAlias = true;
          vimAlias = true;
          configure = {
            #customRC = ''
            # here your custom configuration goes!
            #'';
            packages.myVimPackage = with pkgs.vimPlugins; {
              start = [ vim-nix ];
              opt = [ ];
            };
          };
        };
      })
    ];
  };

  services = {

    ir-toggle.enable = true;
    howdy = {
      enable = true;
      device = "/dev/video2";
    };

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

    # Enable keyring
    gnome3.gnome-keyring.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound.
  nixpkgs.config.pulseaudio = true;
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  hardware.ledger.enable = true;

  programs = { };
}

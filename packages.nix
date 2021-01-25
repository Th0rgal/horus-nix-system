{ pkgs, ... }: {

  environment = {
    systemPackages = with pkgs; [
      neovim wget git pv nodejs brightnessctl system-config-printer ccid libimobiledevice
    ];
    variables.EDITOR = "nvim";
  };

  services.usbmuxd.enable = true;

  imports = [
    ./vscode.nix
    ./modules/howdy.nix
    ./modules/ir_toggle.nix
  ];

  vscode.user = "thomas";
  vscode.homeDir = "/home/thomas";
  vscode.extensions = (with pkgs.vscode-extensions; [
    bbenoist.Nix ms-python.python ms-vscode.cpptools
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "latex-workshop";
        publisher = "James-Yu";
        version = "8.15.0";
        sha256 = "0v4pq3l6g4dr1qvnmgsw148061lngwmk3zm12q0kggx85blki12d";
      }
      {
        name = "better-toml";
        publisher = "bungcip";
        version = "0.3.2";
        sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
      }
      {
        name = "docs-yaml";
        publisher = "docsmsft";
        version = "0.2.6";
        sha256 = "0fsvq77sdp7wln7xfc1yy3x30pdvk2rgy056i3vlrgvlk8gbzi2n";
      }
      {
        name = "markdown-preview-enhanced";
        publisher = "shd101wyy";
        version = "0.5.16";
        sha256 = "0w5w2np8fkxpknq76yv8id305rxd8a1p84p9k0jwwwlrsyrz31q8";
      }
      {
        name = "vsc-material-theme-icons";
        publisher = "Equinusocio";
        version = "1.2.2";
        sha256 = "06xfv8ggli88zg1hyrd7m494fl6bz4fspbxy626nsswq4f26msms";
      }
      {
        name = "cmake-tools";
        publisher = "ms-vscode";
        version = "1.5.3";
        sha256 = "1y2s8rsc94ywbr23x9lhz0idp0d2lbv2vck636blvxsgxmcmmx8d";
      }
    ];

  nixpkgs = {
    latestPackages = [
      "vscode"
      "vscode-extensions"
    ];

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

  programs = {
  };
}

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
        version = "8.13.2";
        sha256 = "1hpsb4f9b8b04j8hfqbr5fsxj2rrbk7x51nl16j1f8vkdcpkd5zx";
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
        version = "0.2.5";
        sha256 = "1ix1l4xvxasbcc2z8hbf5ph3pfzz3vjrhbwc0qrf55b8a4sq8hql";
      }
      {
        name = "markdown-preview-enhanced";
        publisher = "shd101wyy";
        version = "0.5.13";
        sha256 = "0ixw6x6cvfr97ldrmn5ls5kcn788pp6qay05mrsjz7fadmhidyxa";
      }
      {
        name = "vsc-material-theme-icons";
        publisher = "Equinusocio";
        version = "1.2.0";
        sha256 = "0wh295ncm8cbxmw9i3pvg703sn1gw7vp3slbklwjxskb4zivvfk4";
      }
      {
        name = "cmake-tools";
        publisher = "ms-vscode";
        version = "1.5.2";
        sha256 = "e57b8ac689301ea7205a3a04dd5809ae9c08e689360969e7d2003bbd97194f19";
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
    blueman.enable = false;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = false;

  # Enable sound.
  nixpkgs.config.pulseaudio = true;
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

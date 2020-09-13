{ pkgs, ... }: {

  imports = [
    ./vscode.nix
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
        name = "markdown-preview-enhanced";
        publisher = "shd101wyy";
        version = "0.5.13";
        sha256 = "0ixw6x6cvfr97ldrmn5ls5kcn788pp6qay05mrsjz7fadmhidyxa";
      }
    ];
  nixpkgs.latestPackages = [
    "vscode"
    "vscode-extensions"
  ];

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
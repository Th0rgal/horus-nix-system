{ pkgs, ... }: {
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
}
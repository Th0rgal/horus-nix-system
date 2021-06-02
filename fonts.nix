{ pkgs, ... }: {

  fonts = {
    enableDefaultFonts = true; 
    fontDir.enable = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      source-code-pro
      ubuntu_font_family
      (nerdfonts.override { 
        fonts = [ 
          "FiraCode"
          "JetBrainsMono"
        ];
      })
    ];
  };
}
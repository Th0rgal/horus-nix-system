{ pkgs, ... }: {

  fonts = {
    enableDefaultFonts = true; 
    enableFontDir = true;
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
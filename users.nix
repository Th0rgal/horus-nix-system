{ pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.thomas = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "video" "plugdev" ];
    };
  };
}

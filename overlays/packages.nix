self: super: {
  howdy = (super.callPackage ../packages/howdy.nix { });
  ir_toggle = (super.callPackage ../packages/ir_toggle.nix { });
  pam_python = (super.callPackage ../packages/pam_python.nix { });
}
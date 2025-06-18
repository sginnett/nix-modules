{ config, lib, ... }:
{
  options = {
    nix.defaults.enable = lib.mkEnableOption "Enable Nix default settings module";
  };

  config = lib.mkIf config.nix.defaults.enable {
    nix = {
      # Enable nix
      enable = true;
      # Turn on nix-command and flake support (this should be default by now)
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}

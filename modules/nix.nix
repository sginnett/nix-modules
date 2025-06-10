{ config, lib, ... }:
{
  options = {
    defaults.nix.enable = lib.mkEnableOption "Enable Nix settings module";
  };

  config = lib.mkIf config.defaults.nix.enable (lib.mkDefault {
    nix = {
      enable = true;
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    nixpkgs.config.allowUnfree = true;
  });
}

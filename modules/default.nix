{ pkgs, config, lib, ... }:
{
  imports = [
    ./nix.nix
  ];

  options = {
    defaults = {
      enable = lib.mkEnableOption {
        description = "Enable the default module configuration.";
      };
    };
  };

  config = lib.mkIf config.defaults.enable {
    defaults = lib.mkDefault {
      nix.enable = true;
    };
  };
}

{ config, pkgs, lib, systemConfig, outputs, ... }:
{
  options = {
    sginnett.personal = {
      enable = lib.mkEnableOption "sginnett's personal config";
    };
  };

  config.programs.git.enable = lib.mkDefault config.sginnett.personal.enable;
  config.programs.git.sginnett.defaults.enable = lib.mkDefault config.sginnett.personal.enable;

  config.programs.neovim.enable = true; # lib.mkDefault config.sginnett.personal.enable;
  config.programs.neovim.sginnett.defaults.enable = lib.mkDefault config.sginnett.personal.enable;

  config.programs.kitty = {
    enable = lib.mkDefault config.sginnett.personal.enable;
    sginnett.defaults.enable = lib.mkDefault config.sginnett.personal.enable;
  };

  config.programs.fish.enable = true;
  config.home.shell.enableFishIntegration = true;
}

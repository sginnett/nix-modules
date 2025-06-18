{ config, pkgs, lib, ... }:
{
  options = {
    programs.fish.gruvbox.enable = lib.mkEnableOption "fish gruvbox theme";
  };

  config.programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.gruvbox.enable ''theme_gruvbox dark medium'';
  config.environment.systemPackages = lib.mkIf config.programs.fish.gruvbox.enable [ pkgs.fishPlugins.gruvbox ];
}

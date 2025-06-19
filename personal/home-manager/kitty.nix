{ config, lib, ... }: {
  options = {
    programs.kitty.sginnett.defaults.enable = lib.mkEnableOption "sam's kitty config";
  };

  config.programs.kitty.gruvbox-theme.enable = lib.mkDefault (config.programs.kitty.enable && config.programs.kitty.sginnett.defaults.enable);
  config.programs.kitty.fira-code.enable = lib.mkDefault (config.programs.kitty.enable && config.programs.kitty.sginnett.defaults.enable);
}

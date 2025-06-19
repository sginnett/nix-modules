{ config, pkgs, lib, ... }:
{
  options = {
    programs.kitty.gruvbox-theme.enable = lib.mkEnableOption "gruvbox colorscheme";
    programs.kitty.fira-code.enable = lib.mkEnableOption "fira code mono font";
  };

  config.programs.kitty.font = lib.mkIf config.programs.kitty.fira-code.enable {
    name = "FiraCode Nerd Font Mono";
    size = lib.mkDefault 11;
    package = pkgs.nerd-fonts.fira-code;
  };

  config.programs.kitty.extraConfig = lib.mkIf config.programs.kitty.gruvbox-theme.enable ''
    background_opacity 0.9


    # Gruvbox material dark hard
    # vim:ft=kitty
    ## name: Gruvbox Material Dark Hard
    ## author: Sainnhe Park
    ## license: MIT
    ## upstream: https://raw.githubusercontent.com/rsaihe/gruvbox-material-kitty/main/colors/gruvbox-material-dark-hard.conf
    ## blurb: A modified version of Gruvbox with softer contrasts

    background #1d2021
    foreground #d4be98

    selection_background #d4be98
    selection_foreground #1d2021

    cursor #a89984
    cursor_text_color background

    # Black
    color0 #665c54
    color8 #928374

    # Red
    color1 #ea6962
    color9 #ea6962

    # Green
    color2  #a9b665
    color10 #a9b665

    # Yellow
    color3  #e78a4e
    color11 #d8a657

    # Blue
    color4  #7daea3
    color12 #7daea3

    # Magenta
    color5  #d3869b
    color13 #d3869b

    # Cyan
    color6  #89b482
    color14 #89b482

    # White
    color7  #d4be98
    color15 #d4be98
  '';
}

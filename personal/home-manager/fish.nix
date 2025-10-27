{ config, lib, pkgs, ... }:
{

  options = {
    programs.fish.sginnett.defaults.enable = lib.mkEnableOption "Fish Config";
  };

  config= {
    programs.fish = lib.mkIf config.programs.fish.sginnett.defaults.enable {
      enable = true;

      functions = {
        last_history_item = ''
          echo $history[1]
        '';
      };

      shellAbbrs = {
        "!!" = {
          position = "anywhere";
          function = "last_history_item";
        };
        "ga" = "git add";
        "gc" = "git commit";
        "gch" = "git checkout";
        "gb" = "git branch";
        "gr" = "git-recent";
        "gcr" = "git checkout (git-last-branch)";
        "v" = "vim";
      };
    };

    home.shell = lib.mkIf config.programs.fish.sginnett.defaults.enable {
      enableFishIntegration = true;
    };
  };
}

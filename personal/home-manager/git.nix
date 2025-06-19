{ config, systemConfig, pkgs, lib, outputs, ... }:
{
  options = {
    sginnett.personal = {
      gitEmail = lib.mkOption {
        type = outputs.lib.types.email;
        default = systemConfig.sginnett.personal.gitEmail;
      };
      gitUserName = lib.mkOption {
        type = lib.types.str;
        default = systemConfig.sginnett.personal.gitUserName;
      };
    };

    programs.git.sginnett.defaults.enable = lib.mkEnableOption "sginnett's default git config";
  };

  config.programs.git = lib.mkIf config.programs.git.sginnett.defaults.enable {
    userName = config.sginnett.personal.gitUserName;
    userEmail = config.sginnett.personal.gitEmail;
    ignores = [ ".direnv" ".envrc" ];
  };

  config.programs.gh = lib.mkIf (config.programs.git.sginnett.defaults.enable && config.programs.git.enable) {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}

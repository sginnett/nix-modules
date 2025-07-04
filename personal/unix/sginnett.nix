{ config, lib, outputs, pkgs, ... }:
{
  options = {
    sginnett.personal = {
      enable = lib.mkEnableOption "sginnett's personal configuration -- requires access to my git-crypt keys";

      username = lib.mkOption {
        type = lib.types.str;
        default = "sam";
        description = "Username for my profile";
      };

      homeDirectory = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Set home directory for user";
      };

      gitEmail = lib.mkOption {
        type = outputs.lib.types.email;
        description = "Global git email for my profile";
      };
      
      gitUserName = lib.mkOption {
        type = lib.types.str;
        default = "Sam Ginnett";
      };
    };
  };

  config.programs = lib.mkIf config.sginnett.personal.enable {
    fish.defaults.enable = true;
  };
  config.sginnett.personal.gitEmail = lib.mkIf config.sginnett.personal.enable (lib.mkDefault (builtins.readFile ../../private/git-email.txt));
  config.environment = lib.mkIf config.sginnett.personal.enable {
    # TODO: modularize
    systemPackages = with pkgs; [
        neovim

        curl
        wget

        dnsutils
        httpie

        git
        git-crypt
        direnv
        fd
        duf
        dust
        eza
        bat

        jaq
        yq
        ripgrep

        libqalculate
        tldr

        kitty
        brave
        tdf
    ];
  };
  config.home-manager = lib.mkIf config.sginnett.personal.enable {
    # TODO: modularize
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit outputs; systemConfig = config; };
    users."${config.sginnett.personal.username}" = {
      imports = (lib.mapAttrsToList (name: module: module) outputs.homeManagerModules)
                ++ lib.mapAttrsToList (name: module: module) outputs.personalModules.homeManagerModules;

      sginnett.personal.enable = true;

      home.stateVersion = "24.11";
    };
  };

  config.users.users = lib.mkIf (config.sginnett.personal.enable && (config.sginnett.personal.homeDirectory != null)) {
    "${config.sginnett.personal.username}" = {
      home = config.sginnett.personal.homeDirectory;
    };
  };
}

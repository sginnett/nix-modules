{ config, pkgs, lib, ... }:
{
  options = {
    development.latex = {
      enable = lib.mkEnableOption "LaTeX Development";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.texlive.combined.scheme-basic;
        description = "The LilyPond package to use.";
      };
    };
  };

  config.environment.systemPackages = lib.mkIf config.development.latex.enable [
    config.development.latex.package
  ];
}

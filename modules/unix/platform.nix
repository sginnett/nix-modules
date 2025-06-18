{ config, lib, pkgs, ... }:
{
  options = {
    platform = {
      isLinux = lib.mkOption {
        type = lib.types.bool;
        description = "Whether the platform is Linux.";
        default = pkgs.stdenv.targetPlatform.isLinux;
      };

      isDarwin = lib.mkOption {
        type = lib.types.bool;
        description = "Whether the platform is Darwin (macOS).";
        default = pkgs.stdenv.targetPlatform.isDarwin;
      };
    };
  };

  # Use lib.mkForce to enforce the default values
  config = {
    platform.isLinux = lib.mkForce (pkgs.stdenv.targetPlatform.isLinux);
    platform.isDarwin = lib.mkForce (pkgs.stdenv.targetPlatform.isDarwin);
  };
}

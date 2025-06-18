{ pkgs, lib, ... }:
{
  nixpkgs.hostPlatform = "x86_64-darwin";

  sginnett.personal = {
    enable = true;
    username = "sginnett";
    gitEmail = lib.strings.trim (builtins.readFile ../../private/work-email.txt);
    homeDirectory = "/Users/sginnett";
  };

  # users.users.sginnett.home = "/Users/sginnett";

  system.stateVersion = 5;
}

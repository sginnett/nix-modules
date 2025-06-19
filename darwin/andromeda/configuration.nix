{ pkgs, lib, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  sginnett.personal = {
    enable = true;
    username = "sam";
    gitEmail = lib.strings.trim (builtins.readFile ../../private/git-email.txt);
    homeDirectory = "/Users/sam";
  };

  system.stateVersion = 4;
}

{ lib, pkgs, outputs, ... }:

{
  system.stateVersion = "25.05";

  imports = [
    outputs.nixosModules.nix-defaults
  ];

  nix.defaults.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";

  users.users.test = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [ "wheel" ];
    password = "test";
  };
}

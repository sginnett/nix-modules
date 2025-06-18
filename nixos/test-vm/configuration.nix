{ lib, pkgs, outputs, ... }:

{
  system.stateVersion = "25.05";

  imports = [
    outputs.nixosModules.nix-defaults
    outputs.nixosModules."fish-default-shell"
    outputs.nixosModules."fish-functions"
    outputs.nixosModules."fish-greeting"
    outputs.nixosModules."fish-prompt"
  ];

  nix.defaults.enable = true;
  programs.fish.defaultShell = true;

  nixpkgs.hostPlatform = "x86_64-linux";

  users.users.test = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [ "wheel" ];
    password = "test";
  };
}

{ lib, config, ... }:
{
  /* TODO: import tracking once nixpkgs bug is fixed
  imports = [
    ./fish-default-shell.nix
    ./fish-greeting.nix
    ./fish-prompt.nix
    ./fish-gruvbox.nix
  ];
  */

  options = {
    programs.fish.defaults.enable = lib.mkEnableOption "fish shell defaults";
  };

  config.programs.fish = lib.mkIf config.programs.fish.defaults.enable {
    # Enable fish shell
    enable = true;

    # Set fish as the default interactive shell
    defaultShell = true;

    # Enable my default greeting
    defaultGreeting = true;

    # Emable my default prompt
    defaultPrompt = true;

    # Use BabelFish for fish/bash interop
    useBabelfish = true;

    # Gruvbox theme
    gruvbox.enable = true;
  };
}

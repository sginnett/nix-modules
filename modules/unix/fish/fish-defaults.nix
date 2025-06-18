{ lib, config, ... }:
{
  /* TODO: import tracking once nixpkgs bug is fixed
  imports = [
    ./fish-default-shell.nix
    ./fish-greeting.nix
    ./fish-prompt.nix
  ];
  */

  options = {
    programs.fish.defaults.enable = lib.mkEnableOption "fish shell defaults";
  };

  config = lib.mkIf config.programs.fish.defaults.enable {
    # Enable fish shell
    programs.fish.enable = true;

    # Set fish as the default interactive shell
    programs.fish.defaultShell = true;

    # Enable my default greeting
    programs.fish.defaultGreeting = true;

    # Emable my default prompt
    programs.fish.defaultPrompt = true;

    # Use BabelFish for fish/bash interop
    programs.fish.useBabelfish = true;
  };
}

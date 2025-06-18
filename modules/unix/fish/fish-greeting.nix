{pkgs, lib, config, ...}: {
  # Note: nixpkgs module import issue
  /*
  imports = [ ./fish-functions.nix ];
  */
  options = {
    programs.fish.defaultGreeting = lib.mkEnableOption "Enable default greeting based on neofetch";
  };

  config = lib.mkIf config.programs.fish.defaultGreeting {
    programs.fish.functions = {
      fish_greeting = {
        source = ''${pkgs.neofetch}/bin/neofetch'';
      };
    };
  };
}

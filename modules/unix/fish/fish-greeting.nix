{pkgs, ...}: {
  config = {
    programs.fish.functions = {
      fish_greeting = {
        source = ''${pkgs.neofetch}/bin/neofetch'';
      };
    };
  };
}

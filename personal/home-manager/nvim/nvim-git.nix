{ config, lib, pkgs, outputs, ... }:
{
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Show git status of lines
    gitsigns-nvim = {
       opts = {};
       event = "VeryLazy";
    };

    # Interact with Git
    neogit = {
      opts = {};
      cmd = "Neogit";
    };
  };
}

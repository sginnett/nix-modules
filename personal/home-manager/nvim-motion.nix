{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    programs.neovim.lazy.spec = {
      flash-nvim = {
        event = "UiEnter";
        opts = {
          modes = {
            char = {
              enabled = true;
              autohide = false;
              jump_labels = true;
              multi_line = true;
            };
          };
        };
      };

      # Move around the treesitter
      # syntax tree
      treewalker-nvim = {
        cmd = "Treewalker";
        opts = {
          highlight = true;
          highlight_duration = 250;
          highlight_group = "CursorLine";
          jumplist = false;
        };
      };
    };

    xdg.configFile."nvim/lua/flash-motions.lua".source = ./nvim/flash-motions.lua;

  };
}

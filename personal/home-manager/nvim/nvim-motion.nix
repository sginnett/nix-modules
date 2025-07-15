{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    programs.neovim.lazy.spec = {
      flash-nvim = {
        event = "UiEnter";
        opts = {
          modes = {
            char = {
              enabled = false;
            };
          };
        };

        config = ''
          function(_, opts)
            require("flash").setup(opts)
            require("flash-motions").setup()
          end
        '';
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
  };
}

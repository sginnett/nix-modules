{ config, pkgs, lib, outputs, ... }:
{
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Statusline
    lualine-nvim = {
      opts = {
        options = {
          theme = "gruvbox";
          globalstatus = true;
        };

        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" "diff" "diagnostics" ];
          lualine_c = [ "filename" ];
          lualine_x = [ "lsp_status" "filetype" ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
      };

      event = "VeryLazy";
      dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons ];
    };
  };

  config.programs.neovim.options = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    vim.opt.cmdheight = 0;
  };
}

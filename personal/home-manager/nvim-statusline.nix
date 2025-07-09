{ config, pkgs, lib, outputs, ... }:
with outputs.lib.lua; {
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Statusline
    lualine-nvim = {
      opts = {
        options = {
          theme = "gruvbox-material";
          globalstatus = true;
          always_show_tabline = true;
        };

        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "diff" "diagnostics" ];
          lualine_c = [ "filename" ];
          lualine_x = [ "lsp_status" ];
          lualine_y = [ "filetype" "encoding" "fileformat"];
          lualine_z = [ "progress" "location" ];
        };

        tabline = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" ];
          lualine_c = [ "tabs" ];
          lualine_x = [ "%S" ];
          lualine_y = [ ];
          lualine_z = [ "datetime" ];
        };
      };

      event = "VeryLazy";
      dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons ];
    };
  };
}

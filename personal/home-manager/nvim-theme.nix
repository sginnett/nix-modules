{ config, lib, pkgs, outputs, ... }:
with outputs.lib.lua; {
  config = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    programs.neovim.lazy.spec = {
      # Theme, must come first in order for other plugins to pick up values
      gruvbox-material = {
        lazy = false;
        priority = 1000;
        config = mkLuaFunction null [] (mkLuaInline
          ''
            vim.g.gruvbox_material_enable_italic = true;
            vim.cmd.colorscheme('gruvbox-material');
          '');
      };

      # Dev icons for nvim -- used by other plugins
      nvim-web-devicons = {
        shortName = "nvim-web-devicons";
        fullName = "nvim-tree/nvim-web-devicons";
        opts = {};
        config = mkLuaFunction null [ "opts" ] (mkLuaInline ''
          require("nvim-web-devicons").setup(opts)
          -- Load the devicon colors for this theme
          require('tiny-devicons-auto-colors')
        '');
      };

      tiny-devicons-auto-colors-nvim = {
        opts = {
          colors = let colors = lib.mapAttrsToList (name: hex: hex) (
            config.gruvbox-hex);
          in colors;
        };
      };
    };
  };
}

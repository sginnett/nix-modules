{ config, lib, pkgs, options, ... }:
{
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Edit directories like they're files
    oil-nvim = {
      shortName = "oil.nvim";
      fullName = "stevearc/oil.nvim";
      opts = {};
      cmd = "Oil";
      keys = [ [ "<Leader>o" ":Oil<CR>" ] ];
    };

    # File Tree
    nvim-tree-lua = {
      dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons ];
      opts = {};
      cmd = lib.map (name: "NvimTree" + name) [ "" "Open" "Close" "Toggle" "FindFile" "Refresh" ];
    };
  };
}

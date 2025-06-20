{ config, lib, pkgs,... }:
{
  options.programs.neovim.sginnett.edit.enable = lib.mkEnableOption "nvim navigation, textobjects, editing, etc. keybindings and plugins";

  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.edit.enable {
    mini-ai = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    mini-align = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    mini-comment = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    mini-move = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    mini-operators = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    mini-splitjoin = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    mini-surround = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    mini-basics = {
      lazy = false;
      opts = {};
      priority = 5;
    };

    mini-extra = {
      lazy = false;
      opts = {};
      dependencies = with config.programs.neovim.lazy.spec; [ mini-ai ];
    };
  };
}

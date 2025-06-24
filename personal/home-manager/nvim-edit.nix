{ config, lib, pkgs, outputs,... }:
with outputs.lib.lua; {
  options.programs.neovim.sginnett.edit.enable = lib.mkEnableOption "nvim navigation, textobjects, editing, etc. keybindings and plugins";

  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Fixes default w motion for coding, respects camelCase, snake_case, etc.
    vim-wordmotion = {
      lazy = false;
    };

    leap-nvim = {
      lazy = false;
      config = mkLuaFunction null [] (mkLuaInline ''
        require("leap").set_default_mappings()
        vim.keymap.set({'n', 'x', 'o'}, 'gs', function() require('leap.remote').action() end, { desc = "Leap remote" })
      '');
    };

    nvim-neoclip-lua = {
      event = "UiEnter";
      opts = {};
    };

    marks-nvim = {
      event = "VeryLazy";
      opts = {};
    };

    # Tool to help align text in columns
    # trigger with ga or gA
    mini-align = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    # Plugin to toggle commenting of lines anc blocks
    # gc/gcc
    # TODO: possible alternative: Comment.nvim
    mini-comment = {
      lazy = false;
      opts = {};
      priority = 1;
    };
  };
}

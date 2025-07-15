{ config, lib, pkgs, outputs,... }:
with outputs.lib.lua; {
  options.programs.neovim.sginnett.edit.enable = lib.mkEnableOption "nvim navigation, textobjects, editing, etc. keybindings and plugins";

  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Clipboard manager
    nvim-neoclip-lua = {
      event = "UiEnter";
      opts = {
      };
    };

    # Marks manager
    # keymaps for deleting marks and show marks in
    # the signcolumn
    marks-nvim = {
      event = "VeryLazy";
      opts = {};
    };

    # Text Alignment
    vim-easy-align = {
      lazy = false;
    };
  };
}

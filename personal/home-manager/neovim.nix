{ config, pkgs, lib, ... }:
{
  options.programs.neovim = {
    sginnett.defaults.enable = lib.mkEnableOption "sginnett's default config";
  };

  # My personal config
  config.programs.neovim = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    sginnett.lsp.enable = true;
    sginnett.ui.enable = true;
    sginnett.edit.enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    options.vim.opt = {
      termguicolors = true;
      number = true;
      relativenumber = true;
      mouse = "a";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      signcolumn = "yes";
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      foldtext = "";
      foldlevelstart = 2;
      foldnestmax = 10;
      showtabline = 2; # always show tabline
    };

    options.vim.g.mapleader = " ";
    options.vim.g.maplocalleader = " ";
    options.vim.g.markdown_fenced_languages = [ "vim" "lua" "rust" "python" "html" "js=javascript" ];

    extraLuaConfig = ''
      -------- File search path ----------
      vim.opt.path:append { "**" } -- search in subdirectories
    '';

    lazy = {
      enable = true;

      spec = {
        # Dependency of many plugins
        plenary-nvim = {};
      };
    };
  };

}

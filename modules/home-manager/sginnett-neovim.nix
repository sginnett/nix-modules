{ config, pkgs, lib, ... }:
{
  options.programs.neovim = {
    sginnett.defaults.enable = lib.mkEnableOption "sginnett's default config";
  };

  # My personal config
  config.programs.neovim = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    options.vim.opt = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      autoindent = true;
    };

    options.vim.g.mapleader = " ";
  };

}

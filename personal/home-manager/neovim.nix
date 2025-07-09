{ config, pkgs, lib, ... }: {
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

    extraLuaConfig = lib.mkBefore ''
      local status, errmsg = pcall(require, 'pre-lazy')
      if not status then
        vim.notify("Error loading vimscript: " .. errmsg, vim.log.levels.ERROR)
      end
    '';

    lazy = {
      enable = true;

      spec = {
        # Dependency of many plugins
        plenary-nvim = {};
      };
    };
  };

  config.xdg.configFile = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    "nvim/autoload".source = ./nvim/autoload;
    "nvim/lua" = {
      source = ./nvim/lua;
      recursive = true;
    };
    "nvim/after".source = ./nvim/after;
    "nvim/queries".source = ./nvim/queries;
  };

}

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
      -------- File search path ----------
      -- vim.opt.path:append { "**" } -- search in subdirectories
      require('pre-lazy')
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
  };

}

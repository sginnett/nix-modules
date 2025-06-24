{ config, pkgs, lib, outputs, ... }:
{
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Notification system
    nvim-notify = {
      # Load immediately so that no notifications are missed during startup
      # can viw them in history
      lazy = false;
      config = ''
        function()
          vim.notify = require("notify")
        end
      '';
    };
  };
}

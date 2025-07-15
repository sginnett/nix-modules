{ config, lib, pkgs, outputs, ... }:
with outputs.lib.lua; {
  config.programs.neovim = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    lazy.spec = {
      # Prevent bad habits
      hardtime-nvim = {
        opts = {};
        event = "VeryLazy";
      };

      # Keybinding reference
      which-key-nvim = {
        event = "VeryLazy";
        opts = {
          # Note: https://github.com/folke/which-key.nvim/issues/824
          # Which key currently breaks vim.v.count in visual mode
          triggers = [
            # remove x from list until bug fixed
            (mkLuaTable [ "<auto>" ] { mode = "nisotc"; })
          ];
        };
        dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons ];
      };

      # Keybinding helper
      hawtkeys = {
        opts = {
        };
        cmd = [ "Hawtkeys" "HawtkeysAll" "HawtkeysDupes" ];
        package = pkgs.vimUtils.buildVimPlugin {
          name = "hawtkeys.nvim";
          namePrefix = "";
          dependencies = with pkgs.vimPlugins; [
            plenary-nvim
            nvim-treesitter
          ];
          src = pkgs.fetchFromGitHub {
            owner = "tris203";
            repo = "hawtkeys.nvim";
            rev = "v1.2.0";
            sha256 = "sha256-wxxnQvIMHUbDOAbBAswueULavoIoIDHdJK7T09IHD8E=";
          };
        };
      };

      # Create new "modes" and keybinding overlays
      hydra-nvim = {
        lazy = false;
        config = mkLuaFunction null [] (mkLuaInline ''
          require('hydra-setup')
        '');
      };
    };
  };
}

{ config, lib, pkgs, outputs, ... }:
with outputs.lib.lua; {
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Prevent bad habbits
    hardtime-nvim = {
      opts = {};
      event = "VeryLazy";
    };

    # Keybinding reference
    which-key-nvim = {
      event = "VeryLazy";
      opts = {};
      dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons tiny-devicons-auto-colors-nvim ];
    };

    # Keybinding helper
    hawtkeys = {
      opts = {
      };
      cmd = [ "Hawtkeys" "HawtkeysAll" "HawtkeysDups" ];
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
  };
}

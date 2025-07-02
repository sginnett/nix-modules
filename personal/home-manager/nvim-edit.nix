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

    # Macro management
    nvim-recorder = {
      event = "UiEnter";
      opts = {};
      package = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-recorder";
        src = pkgs.fetchFromGitHub {
          owner = "chrisgrieser";
          repo = "nvim-recorder";
          rev = "b045c10032fe3d5d09ef58acd0a10619b7496408";
          sha256 = "sha256-br4OuojCK9Ql7DCBbt+VGRGXr0x01PNymCaWB5+5F7o=";
        };
      };
    };

    # Marks manager
    # keymaps for deleting marks and show marks in
    # statusline
    marks-nvim = {
      event = "VeryLazy";
      opts = {};
    };

    # Hook to trigger LSP folding if provided
    # Adds gitsigns and diagnostics to foldtext
    nvim-origami = {
      event = [ "BufReadPre" "BufNewFile" ];
      # Ensure this loads after treesitter so that the foldexpr gets setup properly
      dependencies = with config.programs.neovim.lazy.spec; [ treesitter ];
      opts = {
        useLspFoldsWithTreesitterFallback = true;
        pauseFoldsOnSearch = true;
        foldtext = {
          enabled = true;
          padding = 3;
          diagnosticsCount = true;
          gitsignsCount = true;
        };
        autoFold = {
          enabled = true;
          kinds = [ "comment" "imports" ];
        };
        foldKeymaps = {
          setup = false;
        };
      };
      
      # Use an updated version with lsp diagnostics integration
      package = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-origami";
        src = pkgs.fetchFromGitHub {
          owner = "chrisgrieser";
          repo = "nvim-origami";
          rev = "8de892244fe9cfa49287843fbd3075615793c0c4";
          sha256 = "sha256-oDo56i8WVndIsvcqtcBvHTC5H3KzBkdFwYcPomQWZx0=";
        };
      };
    };

    # Text Alignment
    vim-easy-align = {
      lazy = false;
    };

    
  };
}

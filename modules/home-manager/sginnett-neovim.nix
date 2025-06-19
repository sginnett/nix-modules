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

    lazy = {
      enable = true;
      extraRuntimePath = let
        grammarPath = pkgs.symlinkJoin {
          name = "nvim-treesitter-grammars";
          paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        };
      in [ "${grammarPath}" ];

      spec = {
        # Theme, must come first in order for other plugins to pick up values
        gruvbox-material = {
          lazy = false;
          priority = 1000;
          config = ''
            function()
              vim.g.gruvbox_material_enable_italic = true;
              vim.cmd.colorscheme('gruvbox-material');
            end
          '';
        };

        # Generic search in files, commands, ...
        telescope-nvim = {
          cmd = "Telescope";
        };

        # Keybindings guide/reminder
        which-key-nvim = {
          event = "VeryLazy";
        };

        # Library used by many plugins
        plenary-nvim = {};

        # Navigation around the document using the `s` command
        leap-nvim = {
          event = "UiEnter";
          config = "function() require(\"leap\").create_default_mappings() end";
        };

        treesitter = {
          package = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
          event = [ "BufReadPre" "BufNewFile" ];
          config = ''function()
            require("nvim-treesitter.configs").setup({
              auto_install = false,
              highlight = {
                enable = true,
              },
              indent = {
                enable = true,
              },
              incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection = "gnn",
                  node_incremental = "grn",
                  scope_incremental = "grc",
                  node_decremental = "grm",
		            },
              },
            })
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
          '';
        };
      };
    };
  };

}

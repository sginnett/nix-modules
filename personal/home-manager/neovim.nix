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
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      autoindent = true;
      foldtext = "";
      foldlevelstart = 2;
      foldnestmax = 10;
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
              -- indent = {
              --  enable = true,
              -- },
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
            -- Prevent vim from folding where my cursor is on InsertLeave
            vim.api.nvim_create_autocmd("InsertLeave", {
              pattern = "*",
              callback = function()
                -- Save and restore fold state to prevent unwanted folding
                local view = vim.fn.winsaveview()
                vim.cmd("normal! zx") -- Recompute folds, but you can use 'zv' to open folds under cursor
                vim.fn.winrestview(view)
              end,
            })
          end
          '';
        };
      };
    };
  };

}

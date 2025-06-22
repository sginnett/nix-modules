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
      tabstop = 2;
      expandtab = true;
      autoindent = true;
      foldtext = "";
      foldlevelstart = 2;
      foldnestmax = 10;
    };

    options.vim.g.mapleader = " ";
    options.vim.g.maplocalleader = " ";

    extraLuaConfig = ''
      -- Highlight on yank
      vim.cmd [[
        augroup YankHighlight
          autocmd!
          autocmd TextYankPost * silent! lua vim.highlight.on_yank()
        augroup end
      ]]

      -------- File search path ---
      vim.opt.path:append { "**" } -- search in subdirectories

      -------- Keymaps --------
      local keymap = vim.api.nvim_set_keymap
      local default_opts = { noremap = true, silent = true }
      local expr_opts = { noremap = true, expr = true, silent = true }

      -- jk to escape insert and terminal mode
      keymap("i", "jk", "<Esc>", default_opts)
      keymap("t", "jk", "<C-\\><C-n>", default_opts)

      -- Better search results (center screen)
      keymap("n", "n", "nzz", default_opts)
      keymap("n", "N", "Nzz", default_opts)

      -- use visual lines for j and k
      keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
      keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)

      -- Re-select visual block after indenting
      keymap("v", "<", "<gv", default_opts)
      keymap("v", ">", ">gv", default_opts)

      -- Keep clipboard when pasting in visual mode
      keymap("v", "p", '"_dP', default_opts)

      -- Buffer switching
      keymap("n", "<M-l>", ":bnext<CR>", default_opts)
      keymap("n", "<M-h>", ":bprevious<CR>", default_opts)

      -- Cancel search highlight with ESC
      keymap("n", "<Esc>", ":nohlsearch<Bar>:echo<CR>", default_opts)

      -- Move line/block selection up/down in visual mode
      keymap("x", "J", ":move '>+1<CR>gv-gv", default_opts)
      keymap("x", "K", ":move '<-2<CR>gv-gv", default_opts)

      -- Resize panes
      keymap("n", "<M-Up>", ":resize +1<CR>", default_opts)
      keymap("n", "<M-Down>", ":resize -1<CR>", default_opts)
      keymap("n", "<M-Left>", ":vertical resize +1<CR>", default_opts)
      keymap("n", "<M-Right>", ":vertical resize -1<CR>", default_opts)

      -- Navigate panes with Ctrl + hjkl
      keymap("n", "<C-h>", "<C-w>h", default_opts)
      keymap("n", "<C-j>", "<C-w>j", default_opts)
      keymap("n", "<C-k>", "<C-w>k", default_opts)
      keymap("n", "<C-l>", "<C-w>l", default_opts)
    '';

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

        alpha-nvim = {
          config = ''
            function()
              local dashboard = require("alpha.themes.dashboard")
              dashboard.section.buttons.val = {
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
                dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
              }

              local function footer()
                local total_plugins = require("lazy.stats").stats().count
                local datetime = os.date "%d-%m-%Y  %H:%M:%S"
                local plugins_text = "\t" .. total_plugins .. " plugins  " .. datetime

                local fortune = require "alpha.fortune"
                local quote = table.concat(fortune(), "\n")

                return plugins_text .. "\n" .. quote
              end

              dashboard.section.footer.val = footer()
              dashboard.section.footer.opts.hl = "Constant"
              dashboard.section.header.opts.hl = "Include"
              dashboard.section.buttons.opts.hl = "Function"
              dashboard.section.buttons.opts.hl_shortcut = "Type"
              dashboard.opts.opts.noautocmd = true

              require("alpha").setup(dashboard.opts)
            end
          '';
          lazy = false;
        };

        neogit = {
          opts = {};
          event = "VeryLazy";
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
                vim.cmd("normal! zv") -- Recompute folds, but you can use 'zv' to open folds under cursor
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

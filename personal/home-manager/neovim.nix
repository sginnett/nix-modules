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
      # autoindent = true;
      foldtext = "";
      foldlevelstart = 2;
      foldnestmax = 10;
      showtabline = 2; # always show tabline
    };

    options.vim.g.mapleader = " ";
    options.vim.g.maplocalleader = " ";

    extraLuaConfig = ''
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
      -- keymap("n", "n", "nzz", default_opts)
      -- keymap("n", "N", "Nzz", default_opts)

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

      spec = {
        # Dependency of many plugins
        plenary-nvim = {};
      };
    };
  };

}

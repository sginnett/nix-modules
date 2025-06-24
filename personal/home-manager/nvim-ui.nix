{ config, lib, pkgs, outputs, ... }:
with outputs.lib.lua; {
  options = {
    programs.neovim.sginnett.ui.enable = lib.mkEnableOption "Enable nvim UI enhancements";
  };
  config = {
    programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
      # Scrollbar on the right side of screen
      nvim-scrollbar = {
        opts = {};
        event = "VeryLazy";
      };

      # Show whitespace in visual mode
			visual-whitespace-nvim = {
			  opts = {};
				event = "VeryLazy";
			};

      # Show trailing whitespace
      mini-trailspace = {
        opts = {};
        event = "VeryLazy";
      };

      # Text object for current indent scope
      # + animation
      mini-indentscope = {
        opts = {};
        event = "VeryLazy";
      };

      # Indentation guides
      indent-blankline-nvim = {
        main = "ibl";
        opts = {};
        event = "VeryLazy";
      };

      undo-glow-nvim = {
        package = pkgs.vimUtils.buildVimPlugin {
          name = "undo-glow-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "y3owk1n";
            repo = "undo-glow.nvim";
            rev = "d2a489fd0549c1a8e39f04c460621d4535fdc033";
            hash = "sha256-+WyALFOR55uwr4hDINz59M+B41T2WnRCD1kDVD2h6UA=";
          };
        };
        opts = {
          animation = {
            enabled = true;
            duration = 500;
            animation_type = "fade";
            fps = 120;
            easing = "in_out_cubic";
            window_scoped = false;
          };
          priority = 4096;
          highlights = {
            undo = {
              hl_color = { bg = config.gruvbox-hex.neutral_orange; };
            };
            redo = {
              hl_color = { bg = config.gruvbox-hex.neutral_orange; };
            };
            yank = {
              hl_color = { bg = config.gruvbox-hex.neutral_yellow; };
            };
            paste = {
              hl_color = { bg = config.gruvbox-hex.neutral_yellow; };
            };
            search = {
              hl_color = { bg = config.gruvbox-hex.neutral_aqua; };
            };
            comment = {
              hl_color = { bg = config.gruvbox-hex.neutral_green; };
            };
            cursor = {
              hl_color = { bg = config.gruvbox-hex.light4; };
            };
          };
        };
      };


      modes-nvim = {
        event = "UiEnter";
        opts = {
          line_opacity = 0.15;
          set_cursor = true;
          set_cursorline = true;
          set_number = true;
          set_signcolumn = true;

          colors = {
            copy = config.gruvbox-hex.neutral_yellow;
            delete = config.gruvbox-hex.neutral_red;
            change = config.gruvbox-hex.neutral_orange;
            format = config.gruvbox-hex.neutral_blue;
            insert = config.gruvbox-hex.neutral_aqua;
            visual = config.gruvbox-hex.neutral_green;
          };
        };
        package = pkgs.vimUtils.buildVimPlugin {
          name = "modes.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "mvllow";
            repo = "modes.nvim";
            rev = "64a78c397b6810fdbbbb5c36b375a5a4337c7be9";
            hash = "sha256-j0E2Hyd03w6x/l2jQAQ1Pr/rbvAe8NbsEc30UHrrNWg=";
          };
        };
      };
    };
  };

  config.programs.neovim.extraLuaConfig = lib.mkIf config.programs.neovim.sginnett.ui.enable ''
  vim.api.nvim_create_autocmd("TextYankPost", {
   desc = "Highlight when yanking (copying) text",
   callback = function(args)
    if vim.v.event.operator ~= "y" then
     return
    end
    require("undo-glow").yank()
   end,
  })

  -- This only handles neovim instance and do not highlight when switching panes in tmux
  vim.api.nvim_create_autocmd("CursorMoved", {
   desc = "Highlight when cursor moved significantly",
   callback = function()
    -- MiniAnimate.execute_after("scroll", function()
    -- MiniAnimate.execute_after("cursor", function()
        require("undo-glow").cursor_moved({
         animation = {
          animation_type = "slide",
         },
        })
      -- end)
    -- end)
   end,
  })

  -- Highlight when focus is gained
  vim.api.nvim_create_autocmd("FocusGained", {
   desc = "Highlight when focus gained",
   callback = function()
    ---@type UndoGlow.CommandOpts
    local opts = {
     animation = {
      animation_type = "slide",
     },
    }

    opts = require("undo-glow.utils").merge_command_opts("UgCursor", opts)
    local pos = require("undo-glow.utils").get_current_cursor_row()

    require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
     s_row = pos.s_row,
     s_col = pos.s_col,
     e_row = pos.e_row,
     e_col = pos.e_col,
     force_edge = opts.force_edge == nil and true or opts.force_edge,
    }))
   end,
  })

  vim.api.nvim_set_keymap('n', 'u', ":lua require('undo-glow').undo()<CR>", { desc = 'Undo with highlight', noremap = true, silent = true});
  vim.api.nvim_set_keymap('n', 'U', ":lua require('undo-glow').redo()<CR>", { desc = 'Redo with highlight', noremap = true, silent = true});
  vim.api.nvim_set_keymap('n', 'p', ":lua require('undo-glow').paste_below()<CR>", { desc = 'Paste below with highlight', noremap = true, silent = true});
  vim.api.nvim_set_keymap('n', 'P', ":lua require('undo-glow').paste_above()<CR>", { desc = 'Paste above with highlight', noremap = true, silent = true});
  vim.api.nvim_set_keymap('n', 'ghp', "p", { desc = 'Paste below without highlight', noremap = true, silent = true});
  vim.api.nvim_set_keymap('n', 'ghP', "P", { desc = 'Paste above without highlight', noremap = true, silent = true});
  '';
}

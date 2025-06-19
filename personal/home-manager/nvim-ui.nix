{ config, lib, pkgs, ... }:
{
  options = {
    programs.neovim.sginnett.ui.enable = lib.mkEnableOption "Enable nvim UI enhancements";
  };

  config = {
    programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.ui.enable {
      # Dev icons for nvim -- used by other plugins
      nvim-web-devicons = {
        shortName = "nvim-web-devicons";
        fullName = "nvim-tree/nvim-web-devicons";
      };

      tiny-devicons-auto-colors-nvim = {
        dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons ];
        opts = {
          colors = let colors = lib.mapAttrsToList (name: hex: hex) (
            config.gruvbox-hex);
          in colors;
        };
        lazy = false;
        # event = "VeryLazy";
      };
/*
      mini-icons = {
        lazy = false;
        opts = {};
      };
*/
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

      # Keybindings guide/reminder
      which-key-nvim = {
        event = "VeryLazy";
        opts = {};
      };


      # status line (bottom bar)
      lualine-nvim = {
        opts = {
          options = {
            theme = "gruvbox";
          };

          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" "diff" "diagnostics" ];
            lualine_c = [ "filename" ];
            lualine_x = [ "lsp_status" "filetype" ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
        };

        event = "VimEnter";
        dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons ];
      };

      # Shows open buffers in a tab-like format at top of the screen
      bufferline-nvim = {
        opts = {
          options = {
            separator_stype = "slant";
            diagnostics = "nvim_lsp";
            hover = {
              enabled = true;
              delay = 200;
              reveal = [ "close" ];
            };
          };
        };

        event = "VimEnter";
      };

      # Scrollbar on the right side of screen
      nvim-scrollbar = {
        event = "VimEnter";
      };

      # Terminal manager
      toggleterm-nvim = {
        event = "VeryLazy";
      };

      # File Tree
      nvim-tree-lua = {
        dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons ];
        opts = {};
        cmd = lib.map (name: "NvimTree" + name) [ "Open" "Close" "Toggle" "FindFile" "Refresh" ];
      };

      # Show git status of lines
      gitsigns-nvim = {
         opts = {};
         event = "VeryLazy";
      };

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


      # ------------------- Telescope ------------------
      telescope-nvim = {
        cmd = [ "Telescope" ];
        opts = {
          defaults = {
            extensions = {
              notify = {};
              file_browser = {
                theme = "ivy";
              };
            };
          };
        };
      };

      telescope-file-browser-nvim = {};

    };
  };
}

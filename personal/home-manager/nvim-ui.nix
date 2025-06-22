{ config, lib, pkgs, ... }:
{
  options = {
    programs.neovim.sginnett.ui.enable = lib.mkEnableOption "Enable nvim UI enhancements";
  };

  config = {
    programs.neovim.options = lib.mkIf config.programs.neovim.sginnett.ui.enable {
      vim = {
        opt.cmdheight = 0;
      };
    };
    programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.ui.enable {

      # ------------------ Theme ------------------
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
      };

      # ----------------- UI Enhancements ----------------
      # Animate motions
      mini-animate = {
        event = "UiEnter";
        opts = {
        };
      };

      # Adds visual indent guides
      # TODO: possible alternative indent-blankline-nvim
      mini-indentscope = {
        event = "UiEnter";
        opts = {};
      };

      # Show trailing whitespace
      mini-trailspace = {
        event = "VeryLazy";
        opts = {};
      };


      # Keybindings guide/reminder
      which-key-nvim = {
        event = "VeryLazy";
        opts = {};
        dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons tiny-devicons-auto-colors-nvim ];
      };


      # status line (bottom bar)
      lualine-nvim = {
        opts = {
          options = {
            theme = "gruvbox";
            globalstatus = true;
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
        dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons tiny-devicons-auto-colors-nvim ];
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
        dependencies = with config.programs.neovim.lazy.spec; [ nvim-web-devicons tiny-devicons-auto-colors-nvim ];
        opts = {};
        cmd = lib.map (name: "NvimTree" + name) [ "" "Open" "Close" "Toggle" "FindFile" "Refresh" ];
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

      tabby-nvim = {
        opts = {};
        event = "UiEnter";
        keys = [
          [ "<Leader>to" ":tabonly<CR>" ]
          [ "<Leader>ta" ":$tabnew<CR>" ]
          [ "<Leader>tc" ":tabclose<CR>" ]
          [ "<Leader>to" ":tabonly<CR>" ]
          [ "<Leader>tn" ":tabnext<CR>" ]
          [ "<Leader>tp" ":tabprevious<CR>" ]
          [ "<Leader>tmp" ":-tabmove<CR>" ]
          [ "<Leader>tmn" ":+tabmove<CR>" ]
        ];
      };


      # ------------------- Telescope ------------------
      telescope-nvim = {
        cmd = [ "Telescope" ];
        config = ''
        function()
          require("telescope").setup {
            defaults = {
              extensions = {
                notify = {},
                ["ui-select"] = {
                  require("telescope.themes").get_dropdown {}
                },
                file_browser = {
                  theme = "ivy";
                },
              },
            },
          }
        end
        '';
        keys = [
          [ "<Leader>ff" ":Telescope find_files<CR>" ]
          [ "<Leader>gr" ":Telescope live_grep<CR>" ]
          [ "<Leader>bf" ":Telescope buffers<CR>" ]
          [ "<Leader>he" ":Telescope help_tags<CR>" ]
          [ "<Leader>co" ":Telescope commands<CR>" ]
          [ "<Leader>di" ":Telescope diagnostics<CR>" ]

        ];
      };

      telescope-file-browser-nvim = {
        config = ''
          function()
            require("telescope").load_extension("file_browser")
          end
        '';
        event = "VeryLazy";
        keys = [
          [ "<Leader>fb" ":Telescope file_browser path=%:p:h select_buffer=true<CR>" ]
        ];
      };

      telescope-ui-select-nvim = {
        event = "UiEnter";
        config = ''
	function()
          require("telescope").load_extension("ui-select")
	end
        '';
      };


      oil-nvim = {
        shortName = "oil.nvim";
        fullName = "stevearc/oil.nvim";
        opts = {};
        cmd = "Oil";
        keys = [ [ "<Leader>o" ":Oil<CR>" ] ];
      };

      hardtime-nvim = {
        opts = {};
        event = "VeryLazy";
      };

      vim-be-better = {
        opts = {};
        cmd = "VimBeBetter";
        package = pkgs.vimUtils.buildVimPlugin {
          name = "vim-be-better";
          src = pkgs.fetchFromGitHub {
            owner = "szymonwilczek";
            repo = "vim-be-better";
            rev = "60e0214598d9d0bac8253e8b53a72eace4af92d3";
            hash = "sha256-bbIhh5A1135UVMdQxUVMEHlqf1tCSbDP8QYQGg/OMa0=";
          };
        };
      };

      modes-nvim = {
        opts = {};
        event = "UiEnter";
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
}

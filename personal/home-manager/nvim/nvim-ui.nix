{ config, lib, pkgs, outputs, ... }:
with outputs.lib.lua; {
  options = {
    programs.neovim.sginnett.ui.enable = lib.mkEnableOption "Enable nvim UI enhancements";
  };
  config = {
    programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {

      # A cute little plugin to show a vim tip every time you open it
      tip-nvim = {
        package = pkgs.vimUtils.buildVimPlugin {
          name = "tip-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "TobinPalmer";
            repo = "tip.nvim";
            rev = "7e875174635da1c49a0e0e4153e0421791192ab7";
            hash = "sha256-9+YjOm2gmTIK6MmAqaAQ5M1IgMX0u5xSLmO+yWtaadk=";
          };
        };
        opts = {
          seconds = 2;
          title = "Tip!";
          url = "https://vtip.43z.one";
        };
        lazy = false;
      };

      # Scrollbar on the right side of screen
      nvim-scrollbar = {
        opts = {};
        event = "VeryLazy";
      };

      # Add short highlight animations to yank, paste, undo, and redo
      tiny-glimmer-nvim = {
        opts = {
          enabled = true;
          overwrite = {
            auto_map = true;
            yank = {
              enabled = true;
              default_animation = {
                name = "fade";
                settings = {
                  from_color = "DiffText";
                  max_duration = 500;
                  min_duration = 500;
                };
              };
            };

            # Note: <count>p is badly broken with this enabled
            paste = {
              enabled = false;
              default_animation = "fade";
              paste_mapping = "p";
              Paste_mapping = "P";
              settings = {
                from_color = "TSWarning";
                max_duration = 500;
                min_duration = 500;
              };
            };

            search = {
              enabled = false;
            };

            undo = {
              enabled = true;
              default_animation = {
                name = "fade";
                settings = {
                  from_color = "DiffDelete";
                  max_duration = 500;
                  min_duration = 500;
                };
              };
              undo_mapping = "u";
            };

            redo = {
              enabled = true;
              default_animation = {
                name = "fade";
                settings = {
                  from_color = "DiffAdd";
                  max_duration = 500;
                  min_duration = 500;
                };
              };
              redo_mapping = "<c-r>";
            };
          };
        };

        event = "VeryLazy";
        package = pkgs.vimUtils.buildVimPlugin {
          name = "tiny-glimmer-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "rachartier";
            repo = "tiny-glimmer.nvim";
            rev = "f92815723c5c3367c4cd11bf365490cb520f8bf3";
            hash = "sha256-1hS7+s00JFH3VyefXJjDZDvyy6GLp9U+66EX16jEqKw=";
          };
        };
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
}

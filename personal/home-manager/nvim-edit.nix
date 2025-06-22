{ config, lib, pkgs,... }:
{
  options.programs.neovim.sginnett.edit.enable = lib.mkEnableOption "nvim navigation, textobjects, editing, etc. keybindings and plugins";
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.edit.enable {

    vim-wordmotion = {
      lazy = false;
    };

    # Basic settings and keybindings
    # mini-basics = {
    #   lazy = false;
    #   opts = {
    #     options = {
    #       # basic settings (e.g. line numbers, cursorline, etc.)
    #       basic = true;
    #       # ui tweaks (winblend, listchars, etc.)
    #       extra_ui = true;
    #       # sets up window boarders
    #       win_boarders = "double";
    #     };
    #
    #     mappings = {
    #       # go gO gy gp gV * # <C-S>
    #       basic = true;
    #       # <C-hjkl> for windows <C-arrow>
    #       windows = true;
    #
    #       move_with_alt = true;
    #     };
    #
    #     autocommands = {
    #       # start insert in terminal highlight yanked text
    #       basic = true;
    #       relnum_in_visual_mode = false;
    #     };
    #   };
    #   priority = 5;
    # };

        # Navigation around the document using the `s` command
    leap-nvim = {
      event = "UiEnter";
      config = "function() require(\"leap\").create_default_mappings() end";
    };


    # Make textobjects from treesitter queries
    # TODO: consider integrating with vim matchup
    nvim-treesitter-textobjects = {
      lazy = false;
      config = let
        keymaps = {
          "i=" = "@assignment.inner";
          "a=" = "@assignment.outer";
          "ih" = "@assignment.rhs";
          "ah" = "@assignment.lhs";
          "iA" = "@attribute.inner";
          "aA" = "@attribute.outer";
          "iB" = "@block.inner";
          "aB" = "@block.outer";
          "if" = "@call.inner";
          "af" = "@call.outer";
          "ic" = "@class.inner";
          "ac" = "@class.outer";
          "i/" = "@comment.inner";
          "a/" = "@comment.outer";
          "iI" = "@conditional.inner";
          "aI" = "@conditional.outer";
          "iR" = "@frame.inner";
          "aR" = "@frame.outer";
          "iF" = "@function.inner";
          "aF" = "@function.outer";
          "il" = "@loop.inner";
          "al" = "@loop.outer";
          "in" = "@number.inner";
          "ia" = "@parameter.inner";
          "aa" = "@parameter.outer";
          "ix" = "@regex.inner";
          "ax" = "@regex.outer";
          "ir" = "@return.inner";
          "ar" = "@return.outer";
          "iS" = "@scopename.inner";
          "a;" = "@statement.outer";
        };
        mkKeymaps = (prefix: lib.strings.concatLines (
          lib.mapAttrsToList (name: value: "[\"${prefix}${name}\"] = \"${value}\",")
            keymaps
        ));
      in ''
        function()
        require("nvim-treesitter.configs").setup({
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ${mkKeymaps ""}
              },
            },
            swap = {
              enable = true,
              swap_next = {
                ${mkKeymaps "<leader>s"}
              },
              swap_previous = {
                ${mkKeymaps "<leader>S"}
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ${mkKeymaps "]"}
              },
              goto_next_end = {
                ${mkKeymaps "g]"}
              },
              goto_previous_start = {
                ${mkKeymaps "["}
              },
              goto_previous_end = {
                ${mkKeymaps "g["}
              },
              goto_next = {
                ${mkKeymaps "<M-g>]"}
              },
              goto_previous = {
                ${mkKeymaps "<M-g>["}
              },
            },
          }
        })
        end'';
    };

    # a - around, i - inside, an/in - around/inside next, al/il - around/inside last
    # g[ g] - goto next/pervious
    # defined text objects are ()[]{}'"`<>|
    # t - tag, f - function call, a - argument, b - any {}[](), q - any quotes, ? - prompt
    # ' ' and '_' for surrounded by spaces/underscores
    # mini-ai = {
    #   lazy = false;
    #   dependencies = with config.programs.neovim.lazy.spec; [
    #     nvim-treesitter-textobjects
    #   ];
    #   config = ''
    #     function()
    #       local gen_spec = require("mini.ai").gen_spec
    #       local gen_ai_spec = require("mini.extra").gen_ai_spec
    #       require("mini.ai").setup({
    #         custom_textobjects = {
    #           G = gen_ai_spec.buffer(),
    #           D = gen_ai_spec.diagnostic(),
    #           L = gen_ai_spec.line(),
    #           N = gen_ai_spec.number(),
    #           f = false,
    #           a = false,
    #         }
    #       })
    #     end
    #   '';
    #   priority = 1;
    # };

    # Tool to help align text in columns
    # trigger with ga or gA
    mini-align = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    # Plugin to toggle commenting of lines anc blocks
    # gc/gcc
    # TODO: possible alternative: Comment.nvim
    mini-comment = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    # Plugin to help with moving text
    # todo <number>gk doesn't seem to work in visual mode
    # mini-move = {
    #   lazy = false;
    #   opts = {
    #     mappings = {
    #       left = "gh";
    #       right = "gl";
    #       up = "gk";
    #       down = "gj";
    #
    #       line_left = "gh";
    #       line_right = "gl";
    #       line_up = "gk";
    #       line_down = "gj";
    #     };
    #   };
    #   priority = 1;
    # };

    # Text operators plugin
    # gx - exchange, gm - multiply, gr replace (with register), gs - sort, g= - evaluate
    mini-operators = {
      lazy = false;
      opts = {
        sort = {
          prefix = "ms";
        };
      };
      priority = 1;
    };

    # Split/join lines
    mini-splitjoin = {
      lazy = false;
      opts = {};
      priority = 1;
    };

    nvim-surround = {
      lazy = false;
      opts = {
        keymaps = {
          visual = "gS";
        };
      };
    };

    # Extra functionality
    # Adds a few text objects
    mini-extra = {
      lazy = false;
      opts = {};
    };

    nvim-neoclip-lua = {
      event = "UiEnter";
      opts = {};
    };

    marks-nvim = {
      event = "VeryLazy";
      opts = {};
    };

    tiny-inline-diagnostic-nvim = {
      event = "LspAttach";
      priority = 1000;
      config = ''
        function()
          require("tiny-inline-diagnostic").setup()
          vim.diagnostic.config({ virtual_text = false })
        end
      '';
    };


    hawtkeys = {
      opts = {};
      event = "VeryLazy";
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

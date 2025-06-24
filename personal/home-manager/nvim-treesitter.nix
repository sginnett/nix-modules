{ config, pkgs, outputs, lib, ... }:
with outputs.lib.lua; {
  config.programs.neovim.lazy = let
    treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  in lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    spec = {
      treesitter = {
        package = treesitter;
        event = [ "BufReadPre" "BufNewFile" ];
        opts = {
          auto_install = false;
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "gnn";
              node_incremental = "grn";
              scope_incremental = "grc";
              node_decremental = "grm";
            };
          };
        };
        config = mkLuaFunction null [ "opts" ] (mkLuaInline
        ''
          require("nvim-treesitter.configs").setup(opts)
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        '');
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
    };

    extraRuntimePath = let
      grammarPath = pkgs.symlinkJoin {
        name = "nvim-treesitter-grammars";
        paths = treesitter.dependencies;
      };
    in [ "${grammarPath}" ];
  };
}

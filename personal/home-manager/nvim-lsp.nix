# Neovim LSP support
{ config, pkgs, lib, outputs, ... }:
with outputs.lib.lua; {
  options = {
    programs.neovim.sginnett.lsp.enable = lib.mkEnableOption "Neovim Lsp Support";
  };

  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.lsp.enable {
    nvim-lspconfig = {
      lazy = false;
      config = mkLuaInline ''require("lsp")'';
    };

    none-ls-nvim = {
      event = "VeryLazy";
      config = mkLuaFunction null [] (mkLuaInline ''
        local null_ls = require("null-ls")
        local cspell = require("cspell")
        null_ls.setup({
          sources = {
            null_ls.builtins.code_actions.gitsigns,
            cspell.diagnostics.with({
              diagnostics_postprocess = function(diagnostic)
                diagnostic.severity = vim.diagnostic.severity.HINT
              end
            }),
            cspell.code_actions,
          }
        })
      '');
    };

    friendly-snippets = {
      lazy = false;
    };

    luasnip = {
      lazy = false;
      dependencies = with config.programs.neovim.lazy.spec; [ friendly-snippets ];
      shortName = "LuaSnip";
      fullName = "L3MON4D3/LuaSnip";
      opts = {
        enable_autosnippets = true;

        update_events = ["TextChanged" "TextChangedI"];

        ext_ops = {
        };
      };
      config = mkLuaFunction null [ "plugin" "opts" ] (mkLuaInline ''
        local opts = opts
        local types = require("luasnip.util.types")
        opts.ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = {{"●", "Question"}},
              hl_mode = "combine"
            }
          },
          [types.insertNode] = {
            active = {
              virt_text = {{"●", "LspInlayHint"}},
              hl_mode = "combine"
            }
          }
        }
        require("luasnip").config.setup(opts)
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets";})
      '');
    };

    cspell-nvim = {
      lazy = true;
    };

    blink-cmp = {
      event = "InsertEnter";
      dependencies = with config.programs.neovim.lazy.spec; [ luasnip ];
      opts = {
        keymap.preset = "super-tab";
        sources = {
          default = [ "lsp" "copilot" "snippets" "path" "buffer" ];
          providers = {
            copilot = {
              name = "copilot";
              module = "blink-copilot";
              score_offset = 100;
              async = true;
            };
          };
        };

        signature = {
          enabled = true;
        };

        completion = {
          documentation = {
            auto_show = true;
          };
        };

        snippets = {
          preset = "luasnip";
        };
      };
    };


    blink-copilot = {
      opts = {
      };
    };

    trouble-nvim = {
      opts = {};
      cmd = "Trouble";
    };
    # Auto pairs
    nvim-autopairs = {
      opts = {
      };
      config = mkLuaFunction null [ "opts" ] (mkLuaInline ''
        require("nvim-autopairs").setup(opts)
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")
        local cond = require("nvim-autopairs.conds")
        local ts_conds = require("nvim-autopairs.ts-conds");
        npairs.add_rules({
          Rule("= ", ";", "nix")
            :with_pair(cond.not_before_char("=", 1)) -- don't add ; after ==
            :with_pair(cond.not_before_char("!", 1)), -- don't add ; after !=
          Rule("with ", ";", "nix")
            :with_pair(function(opts)
              if opts.col == 5 then return true end
              end
             )
            :with_pair(cond.before_text(" with"))
            :with_pair(cond.none),
          Rule("", ";")
            :with_move(function(opts) return opts.char == ";" end)
            :with_pair(function() return false end)
            :with_del(function(opts) return opts.char == ";" end)
            :with_cr(function() return false end)
            :use_key(";")
        })
      '');
      event = "InsertEnter";
    };

    tiny-inline-diagnostic-nvim = {
      event = "LspAttach";
      priority = 1000;
      config = ''
        function()
          require("tiny-inline-diagnostic").setup()
          vim.diagnostic.config({
            virtual_text = false
          })
        end
      '';
    };


    render-markdown-nvim = {
      ft = "markdown";
      dependencies = with config.programs.neovim.lazy.spec; [ treesitter nvim-web-devicons ];
      opts = {};
    };
  };

  config.xdg.configFile."nvim/lua/lsp.lua".source = ./nvim/lsp.lua;
  config.xdg.configFile."nvim/snippets".source = ./nvim/snippets;

  config.home.packages = [ pkgs.nil pkgs.lua-language-server pkgs.nodePackages.cspell pkgs.luajitPackages.jsregexp ];
}

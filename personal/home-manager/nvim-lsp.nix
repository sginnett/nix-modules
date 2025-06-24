# Neovim LSP support
{ config, pkgs, lib, outputs, ... }:
with outputs.lib.lua; {
  options = {
    programs.neovim.sginnett.lsp.enable = lib.mkEnableOption "Neovim Lsp Support";
  };

  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.lsp.enable {
    nvim-lspconfig = {
      lazy = false;
      config = mkLuaFunction null [] (mkLuaInline
      ''
        vim.lsp.enable("nil_ls");
      '');
    };

    blink-cmp = {
      event = "InsertEnter";
      opts = {
        keymap.preset = "super-tab";
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
          vim.diagnostic.config({ virtual_text = false })
        end
      '';
    };
  };

  config.home.packages = [ pkgs.nil ];
}

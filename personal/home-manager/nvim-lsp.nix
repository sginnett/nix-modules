# Neovim LSP support
{ config, pkgs, lib, ... }:
{
  options = {
    programs.neovim.sginnett.lsp.enable = lib.mkEnableOption "Neovim Lsp Support";
  };

  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.lsp.enable {
    # LSP configurations
    nvim-lspconfig = {
      lazy = false;
      config = ''
      function()
        vim.lsp.enable("nil_ls")
      end
      '';
    };

    # Completion support
    blink-cmp = {
      dependencies = with config.programs.neovim.lazy.spec; [ friendly-snippets ];
      event = "InsertEnter";
      opts = {
        keymap.preset = "super-tab";
      };
    };

    # Auto pairs
    nvim-autopairs = {
      opts = {
        #        map_cr = true;
      };
      event = "InsertEnter";
    };

    # Snippets provider
    friendly-snippets = {};

    # LSP diagnostics window
    trouble-nvim = {
      opts = {};
      cmd = [ "Trouble" ];
    };

    # Github Copilot auto-completion support
    copilot-lua = {
      event = "InsertEnter";
      opts = {
        suggestion = {
          enabled = true;
          auto_trigger = true;
          debounce = 75;
          keymap = {
            accept = "<M-CR>";
            accept_line = "<M-;>";
            next = "<M-]>";
            prev = "<M-[>";
            dismiss = "<M-e>";
          };
        };
      };
      cmd = [ "Copilot" ];
    };

    # Copilot chat
    CopilotChat-nvim = {
      opts = {};
      cmd = lib.map (cmd: "CopilotChat" + cmd) [
        "" "Open" "Close" "Toggle" "Stop" "Reset"
        "Save" "Load" "Prompts" "Models" "Agents"
      ];
    };
  };
  config.programs.neovim.withNodeJs = lib.mkIf config.programs.neovim.sginnett.lsp.enable true;

  config.home.packages = lib.mkIf config.programs.neovim.sginnett.lsp.enable [ pkgs.nil ];

}

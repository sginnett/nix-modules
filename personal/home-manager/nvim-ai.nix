{ config, lib, pkgs, outputs, ... }:
{
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Github Copilot auto-completion support
    copilot-lua = {
      event = "InsertEnter";
      requiresNodeJs = true;
      opts = {
        suggestion = {
          enabled = false;
          # auto_trigger = true;
          # debounce = 75;
          # keymap = {
          #   accept = "<M-CR>";
          #   accept_line = "<M-;>";
          #   next = "<M-]>";
          #   prev = "<M-[>";
          #   dismiss = "<M-e>";
          # };
        };
        panel = {
          enabled = false;
        };
        filetypes = {
          markdown = true;
          help = true;
        };
      };
      cmd = [ "Copilot" ];
    };

    # Copilot chat
    CopilotChat-nvim = {
      requiresNodeJs = true;
      opts = {
        mappings = {
          reset = {
            normal = "<M-r>";
            insert = "<M-r>";
          };
        };
      };
      cmd = lib.map (cmd: "CopilotChat" + cmd) [
        "" "Open" "Close" "Toggle" "Stop" "Reset"
        "Save" "Load" "Prompts" "Models" "Agents"
      ];
    };
  };
}

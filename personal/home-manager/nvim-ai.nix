{ config, lib, pkgs, outputs, ... }:
{
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    # Github Copilot auto-completion support
    copilot-lua = {
      event = "InsertEnter";
      requiresNodeJs = true;
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
      requiresNodeJs = true;
      opts = {};
      cmd = lib.map (cmd: "CopilotChat" + cmd) [
        "" "Open" "Close" "Toggle" "Stop" "Reset"
        "Save" "Load" "Prompts" "Models" "Agents"
      ];
    };
  };
}

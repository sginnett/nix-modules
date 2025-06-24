{ config, lib, pkgs, outputs, ... }:
with outputs.lib.lua; {
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    telescope-nvim = {
      cmd = [ "Telescope" ];
      config = let opts = {
            extensions = {
              notify = {};
              ui-select = [
                (mkLuaInline "require(\"telescope.themes\").get_dropdown {}")
              ];
              file_browser = {
                theme = "ivy";
              };
            };
        }; in mkLuaFunction null [] [ (mkLuaInline "require('telescope').setup") opts ];
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
      config = mkLuaFunction null [] (mkLuaInline
        ''require("telescope").load_extension("file_browser")''
      );
      event = "VeryLazy";
      keys = [
        [ "<Leader>fb" ":Telescope file_browser path=%:p:h select_buffer=true<CR>" ]
      ];
    };

    telescope-ui-select-nvim = {
      event = "UiEnter";
      config = mkLuaFunction null [] (mkLuaInline
       ''require("telescope").load_extension("ui-select")''
      );
    };
  };
}

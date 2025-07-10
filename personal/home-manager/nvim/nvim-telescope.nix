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
        # Invoke Telescope with <Leader>f..
        [ "<Leader>ft" ":Telescope<CR>" ]

        # File searching
        [ "<Leader>ffi" ":Telescope find_files<CR>" ]
        [ "<Leader>ffb" ":Telescope file_browser path=%:p:h select_buffer=true<CR>" ]
        [ "<Leader>ffg" ":Telescope git_files<CR>" ]
        [ "<Leader>ffr" ":Telescope oldfiles<CR>" ]
        [ "<Leader>fgr" ":Telescope live_grep<CR>" ]

        # Help and reference
        [ "<Leader>fhe" ":Telescope help_tags<CR>" ]
        [ "<Leader>fcm" ":Telescope commands<CR>" ]
        [ "<Leader>fmn" ":Telescope man_pages<CR>" ]
        [ "<Leader>fkm" ":Telescope keymaps<CR>" ]

        # Lsp interaction
        [ "<Leader>fdi" ":Telescope diagnostics<CR>" ]
        [ "<Leader>fqf" ":Telescope quickfix<CR>" ]
        [ "<Leader>fll" ":Telescope loclict<CR>"]
        [ "<Leader>fds" ":Telescope lsp_document_symbols<CR>" ]
        [ "<Leader>fws" ":Telescope lsp_workspace_symbols<CR>" ]
        [ "<Leader>fdws" ":Telescope lsp_dynamic_workspace_symbols<CR>" ]
        [ "<Leader>fde" ":Telescope lsp_definitions<CR>" ]
        [ "<Leader>fre" ":Telescope lsp_references<CR>" ]
        [ "<Leader>fim" ":Telescope lsp_implementations<CR>" ]
        [ "<Leader>ftd" ":Telescope lsp_type_definitions<CR>" ]
        [ "<Leader>fic" ":Telescope lsp_incoming_calls<CR>" ]
        [ "<Leader>foc" ":Telescope lsp_outgoing_calls<CR>" ]
        [ "<Leader>foc" ":Telescope lsp_outgoing_calls<CR>" ]

        # Searching various vim features
        [ "<Leader>fma" ":Telescope marks<CR>" ]
        [ "<Leader>fbf" ":Telescope buffers<CR>" ]
        [ "<Leader>fre" ":Telescope registers<CR>" ]
        [ "<Leader>fac" ":Telescope autocommands<CR>" ]
        [ "<Leader>fch" ":Telescope command_history<CR>" ]
        [ "<Leader>fju" ":Telescope jumplist<CR>" ]
        [ "<Leader>ftr" ":Telescope treesitter<CR>" ]
        [ "<Leader>fhl" ":Telescope highlights<CR>" ]
        [ "<Leader>fcl" ":Telescope colorscheme<CR>" ]
        [ "<Leader>fcb" ":Telescope current_buffer_fuzzy_find<CR>" ]
        [ "<Leader>fct" ":Telescope current_buffer_tags<CR>" ]
        [ "<Leader>fvo" ":Telescope vim_options<CR>" ]
        [ "<Leader>fts" ":Telescope tag_stack<CR>" ]
        [ "<Leader>fss" ":Telescope spell_suggest<CR>" ]
        [ "<Leader>fta" ":Telescope tags<CR>" ]
        [ "<Leader>fsy" ":Telescope symbols<CR>" ]
        [ "<Leader>fsh" ":Telescope search_history<CR>" ]

        # Plugin Integrations
        [ "<Leader>fnc" ":Telescope neoclip<CR>" ]
        [ "<Leader>fno" ":Telescope notify<CR>" ]
      ];
    };

    telescope-file-browser-nvim = {
      config = mkLuaFunction null [] (mkLuaInline
        ''require("telescope").load_extension("file_browser")''
      );
    };

    telescope-ui-select-nvim = {
      event = "UiEnter";
      config = mkLuaFunction null [] (mkLuaInline
       ''require("telescope").load_extension("ui-select")''
      );
    };
  };
}

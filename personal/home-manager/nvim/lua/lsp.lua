-- My Lsp config
return function()
  ------------------ Enabled Lsp(s) ----------------------------
  vim.lsp.enable("nil_ls")
  vim.lsp.enable("lua_ls")
  vim.lsp.enable("none_ls")
  vim.lsp.enable("basedpyright")

  ------------------ Language Specific Config ------------------------
  vim.lsp.config("lua_ls", {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = {
            'lua/?.lua',
            'lua/?/init.lua',
          },
        },

        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
          }
        },
      })
    end,

    settings = {
      Lua = {},
    }
  })

  ------------------ Diagnostic Config -----------------------------
  vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    signs = {
      text = {
        -- Define icons used for diagnostics
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN]  = "",
        [vim.diagnostic.severity.INFO]  = "",
        [vim.diagnostic.severity.HINT]  = "󰌶",
      }
    }
  })
end

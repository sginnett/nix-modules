local M = {}

function M.flash_jump()
  require("flash").jump({
    search = { multi_window = true }
  })
end

function M.flash_treesitter()
  require("flash").treesitter({
    label = {
      rainbow = {
        enabled = true,
        shade = 9,
      }
    }
  })
end

function M.flash_remote()
  require("flash").remote()
end

function M.flash_treesitter_search()
  require("flash").treesitter_search({
    jump = { pos = "range" },
    label = {
      rainbow = {
        enabled = true,
        shade = 9,
      },
    },
    remote_op = {
      -- TODO: restore setting does not seem to be working
      restore = true,
    },
  })
end

function M.flash_remote_diagnostics()
  require("flash").jump({
    action = function(match, state)
      vim.api.nvim_win_call(match.win,
        function()
          vim.api.nvim_win_set_cursor(match.win, match.pos)
          vim.diagnostic.open_float()
        end)
      state:restore()
    end,
  })
end

function M.flash_remote_code_action()
  require("flash").jump({
    action = function(match, state)
      vim.api.nvim_win_call(match.win,
        function()
          vim.lsp.buf.code_action({ range = { start = match.pos, [ "end" ] = match.pos }})
        end)
    end,
  })
end

function M.setup()
  vim.keymap.set({"n", "x", "o"}, "<Plug>(FlashJump)", M.flash_jump)
  vim.keymap.set({"n", "x", "o"}, "<Plug>(FlashTreesitter)", M.flash_treesitter)
  vim.keymap.set("o", "<Plug>(FlashRemote)", M.flash_remote)
  vim.keymap.set("o", "<Plug>(FlashTreesitterSearch)", M.flash_treesitter_search)
  vim.keymap.set("n", "<Plug>(FlashRemoteDiagnostic)", M.flash_remote_diagnostics)
end

return M

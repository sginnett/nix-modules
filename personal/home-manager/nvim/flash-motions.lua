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
    label = {
      jump = { pos = "range" },
      rainbow = {
        enabled = true,
        shade = 9,
      },
      remote_op = {
        -- TODO: restore setting does not seem to be working
        restore = true,
      }
    }
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

return M

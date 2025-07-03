local km = vim.keymap
local flash = require("flash-motions")

----------------- Helper Functions --------------------------------------------
local function noremap(modes, lhs, rhs, desc, opts)
  local opts = vim.deepcopy(opts)
  if opts == nil then
    opts = {}
  end
  opts.noremap = true
  opts.silent = true
  opts.desc = desc
  km.set(modes, lhs, rhs, opts)
end

local function nnoremap(lhs, rhs, desc, opts)
  noremap("n", lhs, rhs, desc, opts)
end

local function xnoremap(lhs, rhs, desc, opts)
  noremap("x", lhs, rhs, desc, opts)
end

local function onoremap(lhs, rhs, desc, opts)
  noremap("o", lhs, rhs, desc, opts)
end

local function inoremap(lhs, rhs, desc, opts)
  noremap("i", lhs, rhs, desc, opts)
end

local function isnoremap(lhs, rhs, desc, opts)
  noremap({"i", "s"}, lhs, rhs, desc, opts)
end

local function nxnoremap(lhs, rhs, desc, opts)
  noremap({ "n", "x" }, lhs, rhs, desc, opts)
end

local function nxonoremap(lhs, rhs, desc, opts)
  noremap({ "n", "x", "o" }, lhs, rhs, desc, opts)
end


-----------------------------Default Behavior Modifiers ------------------------
-- Cancel search highlight with esc
nnoremap("<Esc>", "<Esc>:nohlsearch<CR>", "Escape and unhighlight search")

-- use visual lines for j and k with no count
nnoremap("k", "v:count == 0 ? 'gk' : 'k'", "step visual lines with k", { expr = true })
nnoremap("j", "v:count == 0 ? 'gj' : 'j'", "step visual lines with j", { expr = true })

-- Make space a noop in visual, normal and operator pending
nxonoremap("<Space>", "<Nop>", "No operation for space")

-- re-select after an indent operator
xnoremap("<", "<gv", "re-highlight after indent")
xnoremap(">", ">gv", "re-highlight after indent")

-----------------------------Buffer switching ----------------------------------
-- nnoremap("<M-l>", ":bnext<CR>")
-- nnoremap("<M-l>", ":bprevious<CR>")

-----------------------------Window Management ---------------------------------
-- Resize panes
nnoremap("<M-Up>", ":resize +1<CR>", "Increase vertical size of window")
nnoremap("<M-Down>", ":resize -1<CR>", "Decrease vertical size of window")
nnoremap("<M-Left>", ":vertical resize -1<CR>", "Decrease horizontal size of window")
nnoremap("<M-Right>", ":vertical resize +1<CR>", "Increase horizontal size of window")

-- Navigate panes with Ctrl + h/j/k/l
nnoremap("<C-h>", "<C-w>h", "move to left window")
nnoremap("<C-j>", "<C-w>j", "move to bottom window")
nnoremap("<C-k>", "<C-w>k", "move to top window")
nnoremap("<C-l>", "<C-w>l", "move to left window")

-----------------------------Extra Actions -------------------------------------
inoremap("<M-U>", "<Esc>gUiWEa", "make the most recently typed WORD uppercase")
inoremap("<M-u>", "<Esc>guiWEa", "make the most recently typed WORD lowercase")

nxnoremap("ga", "<Plug>(EasyAlign)", "align selected text")

-----------------------------Extra Motions -------------------------------------
nxonoremap("s", flash.flash_jump, "Jump to search")
nxonoremap("S", flash.flash_treesitter, "Select surrounding treesitter node")

onoremap("r", flash.flash_remote, "Remote operation")
onoremap("R", flash.flash_treesitter_search, "Search treesitter nodes")

nnoremap("<Leader>vd", flash.flash_remote_diagnostics)

nnoremap("<M-h>", "<cmd>Treewalker Left<Cr>", "Move to sibling node")
nnoremap("<M-j>", "<cmd>Treewalker Down<Cr>", "Move to parent node")
nnoremap("<M-k>", "<cmd>Treewalker Up<Cr>", "Move to child node")
nnoremap("<M-l>", "<cmd>Treewalker Right<Cr>", "Move to sibling node")

nnoremap("<M-H>", "<cmd>Treewalker SwapLeft<Cr>", "Move to sibling node")
nnoremap("<M-J>", "<cmd>Treewalker SwapDown<Cr>", "Move to parent node")
nnoremap("<M-K>", "<cmd>Treewalker SwapUp<CR>", "Move to child node")
nnoremap("<M-L>", "<cmd>Treewalker SwapRight<CR>", "Move to sibling node")

----------------------------Snippets -------------------------------------------
local ls = require("luasnip")

-- inoremap("<C-K>", function() ls.expand() end, "Manually trigger snippet")
isnoremap("<C-L>", function() ls.jump(1) end, "Jump to last snippet section")
isnoremap("<C-J>", function() ls.jump(1) end, "Jump to next snippet section")
isnoremap(
  "<C-E>",
  function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end,
  "Toggle snippet choice"
)

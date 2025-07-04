local Hydra = require("hydra")

Hydra{
  name = "Window",
  mode = "n",
  body = "<Leader>w",
  color = "red",
  -- hint = [[Window Mode]],
  config = {

  },
  heads = {
    -- Moving Between Windows
    { "h", "<C-W>h" },
    { "j", "<C-W>j" },
    { "k", "<C-W>k" },
    { "l", "<C-W>l" },
    { "P", "<C-W>P" },
    { "p", "<C-W>p" },
    { "W", "<C-W>W" },
    { "w", "<C-W>w" },
    { "b", "<C-W>b" },
    { "t", "<C-W>t" },
    { "gt", "<C-W>gt" },
    { "gT", "<C-W>gT" },
    { "g<Tab>", "<C-W>g<Tab>" },

    -- Resizing Windows
    { "<Left>", "<C-W><" },
    { "<Right>", "<C-W>>" },
    { "<Up>", "<C-W>+" },
    { "<Down>", "<C-W>-" },
    { "=", "<C-W>=" },
    { "_", "<C-W>_" },
    { "|", "<C-W>|" },

    -- Moving Windows
    { "H", "<C-W>H" },
    { "J", "<C-W>J" },
    { "K", "<C-W>K" },
    { "L", "<C-W>L" },
    { "R", "<C-W>R" },
    { "r", "<C-W>r" },
    { "T", "<C-W>T" },
    { "x", "<C-W>x" },

    -- Opening and Closing Windows
    { "^", "<C-W>^" },
    { "c", "<C-W>c" },
    { "f", "<C-W>f" },
    { "F", "<C-W>F" },
    { "g<C-]>", "<C-W>g<C-]>" },
    { "g}", "<C-W>g}" },
    { "gf", "<C-W>gf" },
    { "gF", "<C-W>gF" },
    { "i", "<C-W>i" },
    { "n", "<C-W>n" },
    { "o", "<C-W>o" },
    { "q", "<C-W>q" },
    { "s", "<C-W>s" },
    { "S", "<C-W>S" },
    { "v", "<C-W>v" },
    { "z", "<C-W>z" },
    { "}", "<C-W>}" },
  },
}

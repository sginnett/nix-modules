" Sets up default options for Neovim
function! opts#Setup() "{{{1
  " Options {{{2
  " Line Numbers
  set number relativenumber
  " Signcolumn
  set signcolumn=yes
  " Default to expandtab and a shiftwidth of 2
  set shiftwidth=2 expandtab softtabstop=-1 shiftround
  " Wrap lines
  set wrap breakindent textwidth=80 showbreak=>
  " Case Sensitivity and Search
  set ignorecase smartcase magic
  " Fold Levels
  set foldenable foldlevelstart=0 foldnestmax=20
  " Tabline and status line always on top/bottom, no winbar
  set showtabline=2 laststatus=3 winbar=""
  " Hide commandline when not in use
  set cmdheight=0
  " Show Command in statusline component
  set showcmd showcmdloc=statusline
  " Mouse
  set mouse=a

  " Leader keys {{{2
  let g:mapleader=" "
  let g:maplocalleader=" "

endfunction "}}}1

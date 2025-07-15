" Sets up default options for Neovim
function! opts#Setup() "{{{1
  " Options {{{2
  "
  " Status Lines and Columns {{{3
  " Relative line numbers
  set number relativenumber
  " Always show signcolumn
  set signcolumn=yes
  " Tabline and status line always on top/bottom, no winbar
  set showtabline=2 laststatus=3 winbar=""
  " Default to expandtab and a shiftwidth of 2
  set shiftwidth=2 expandtab softtabstop=-1 shiftround
  " Hide commandline when not in use
  set cmdheight=0
  " Show Command in statusline component
  set showcmd showcmdloc=statusline

  " Text Display {{{3
  " Wrap lines
  set wrap breakindent textwidth=80 showbreak=>
  " Fold Levels
  set foldenable foldlevelstart=0 foldnestmax=20

  " Search {{{3
  " Case Sensitivity
  set ignorecase smartcase
  " Magic regexes by default
  set magic

  " Misc UI settings {{{3
  " Mouse
  set mouse=a

  " Auto commands {{{2

  " Keymaps {{{2
  "
  " Leader keys {{{3
  let g:mapleader=" "
  let g:maplocalleader=" "

  " Default Behavior Modifiers {{{3
  " unhighlight search on escape
  nnoremap <esc> <esc><cmd>nohlsearch<cr>

  " Step by visual lines if no count is used
  nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

  " Re-select visual selections after indenting
  xnoremap < <gv
  xnoremap > >gv

  " Extra Actions {{{3
  " Capitalize last word
  inoremap <M-u> <esc>gUiWea

  " EasyAlign
  nnoremap ga <Plug>(EasyAlign)
  xnoremap ga <Plug>(EasyAlign)

  " Snippets
  inoremap <C-L> <Plug>luasnip-jump-next
  inoremap <C-J> <Plug>luasnip-jump-prev
  inoremap <C-Y> <Plug>luasnip-expand-snippet
  inoremap <C-Y> <Plug>luasnip-next-choice

  " Surround
  nnoremap gsa <Plug>(nvim-surround-normal)
  nnoremap gsc <Plug>(nvim-surround-change)
  nnoremap gsd <Plug>(nvim-surround-delete)
  nnoremap gss <Plug>(nvim-surround-normal-cur)
  nnoremap gSS <Plug>(nvim-surround-normal-cur-line)
  nnoremap gSa <Plug>(nvim-surround-normal-line)
  nnoremap gSc <Plug>(nvim-surround-change-line)
  xnoremap gs  <Plug>(nvim-surround-visual)
  xnoremap gS  <Plug>(nvim-surround-visual-line)
  inoremap <C-G>s <Plug>(nvim-surround-insert)
  inoremap <C-G>S <Plug>(nvim-surround-insert-line)


  " Extra Motions {{{3
  " Flash -- Remote Operations
  noremap gl <Plug>(FlashJump)
  noremap gL <Plug>(FlashTreesitter)

  onoremap r <Plug>(FlashRemote)
  onoremap R <Plug>(FlashTreesitterSearch)

  nnoremap <leader>rd <Plug>(FlashRemoteDiagnostics)
  nnoremap <leader>ra <Plug>(FlashRemoteCodeAction)

  " Toggling Options
  nnoremap <leader>tw <cmd>set wrap!<cr>
  nnoremap <leader>tn <cmd>set number! relativenumber!<cr>
  nnoremap <leader>t<space> <cmd>if &shiftwidth == 2 set shiftwidth=4  else set shiftwidth=2 endif<cr>
  nnoremap <leader>t<tab> <cmd>set expandtab?<cr>
  nnoremap <leader>tf <cmd>set foldenable!<cr>
endfunction "}}}1


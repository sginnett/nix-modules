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
  " Whitespace
  let g:baselistchars="tab:>-,extends:>,precedes:<,trail:␣"
  let g:listcharsopt=",space:␣,conceal:…,nbsp:·,eol:↵"
  let g:listoptchars=v:false

  let &listchars = g:baselistchars
  set list

  augroup setlistchars
    autocmd!
    autocmd OptionSet shiftwidth,list call opts#SetListChars()
    autocmd BufWinEnter * call opts#SetListChars()
    autocmd VimEnter * call opts#SetInitialListChars()
  augroup END

  " Leader keys {{{2
  let g:mapleader=" "
  let g:maplocalleader=" "

endfunction "}}}1

function! opts#SetListChars() "{{{1
  let multispace = ",leadmultispace:▏"
  let count = 1
  while count < &shiftwidth
    let count += 1
    let multispace .= "⠄"
  endwhile
  let &l:listchars = g:baselistchars .. multispace
  if g:listcharsopt
    let &l:listchars ..= g:listcharsopt
  endif
endfunction "}}}1

function! opts#SetInitialListChars() "{{{
  " Setup listchars in all windows on startup
  tabdo windo call opts#SetListChars()
endfunction "}}}

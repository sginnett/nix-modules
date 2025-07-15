" -----------------------------Whitespace.vim -----------------------------------
"
"  A plugin to make whitespace more visible in vim.

" Variables and Constants "{{{1
"
" Defines the list characters used for each type of whitespace, see h:
" 'listchars'
" TODO: Allow setting these values by the user
let s:displaychars = {
  \"conceal": "…",
  \"eol": "↵",
  \"extends": ">",
  \"lead": "",
  \"leadmultispacecontinue": "⠄",
  \"leadmultispacestart": "▏",
  \"multispace": "",
  \"nbsp": "·",
  \"precedes": "<",
  \"space": "␣",
  \"tab": ">-",
  \"trail": "␣",
\}
" Base set of list chars to enable by default
let s:basechars=["tab","extends","precedes","trail","leadmultispace"]
" Extended set of listchars
" TODO: Allow toggling an 'extended' mode with extra listchars
let s:extendedchars=["space", "nbsp", "eol", "conceal"]
" All list chars defined by neovim
" TODO: use this to validate user configurations
let s:allchars=[
  \"conceal",
  \"eol",
  \"extends",
  \"lead",
  \"leadmultispace",
  \"multispace",
  \"nbsp",
  \"precedes",
  \"space",
  \"tab",
  \"trail",
\]
" Highlight group for trailing whitespace
" Looks good with gruvbox-material
" TODO: make configurable
let s:trailhlgroup="@comment.error"
"}}}1

" Functions
"
" Setup an individual window
function s:SetupWindow() "{{{1
  if !exists('w:trail_whitespace_match_id')
    let w:trail_whitespace_match_id = -1
  endif
  if &buftype != ""
    setlocal nolist
    return s:DestroyMatch()
  endif

  " Setup Match for trailing whitespace
  call s:SetupMatch()
  call s:SetupListChars()
  setlocal list
endfunction "}}}1

" Setup all windows
function s:SetupAllWindows() "{{{1
  tabdo windo call s:SetupWindow()
endfunction "}}}1

" Setup Trailing Space Highlight Match
function s:SetupMatch() "{{{1
  if !exists('w:trail_whitespace_match_id')
    let w:trail_whitespace_match_id = -1
  endif
  if w:trail_whitespace_match_id == -1
    let w:trail_whitespace_match_id = matchadd('TrailingSpace', '\s\+$')
  endif
endfunction "}}}1

" Remove the Trailing Space Highlight Match
function s:DestroyMatch() "{{{1
  if exists('w:trail_whitespace_match_id') && w:trail_whitespace_match_id != -1
    call matchdelete(w:trail_whitespace_match_id)
    let w:trail_whitespace_match_id = -1
  endif
endfunction "}}}1

" Setup Autocommands for configuring ListChars
function s:SetupListCharsAutocmds() "{{{1
  augroup SetupListChars
    autocmd!
    autocmd OptionSet shiftwidth,list call s:SetupListChars()
    autocmd BufWinEnter * call s:SetupListChars()
    autocmd VimEnter * call s:SetInitialListChars()
  augroup END
endfunction "}}}1

" Set the list characters for a particular window
function s:SetupListChars() "{{{1
  let multispace = ",leadmultispace:"
  let multispace ..= s:displaychars["leadmultispacestart"]
  let count = 1
  while count < &shiftwidth
    let count += 1
    let multispace ..= s:displaychars["leadmultispacecontinue"]
  endwhile
  let &l:listchars = s:baselistchars .. multispace
endfunction "}}}1

" Calculate the base set of list characters
function s:SetBaseListChars() "{{{1
  let s:baselistchars = ""
  for char in s:basechars
    if char == "leadmultispace"
      continue
    else
      if s:baselistchars != ""
        let s:baselistchars ..= ","
      endif
      let s:baselistchars ..= char
      let s:baselistchars ..= ":"
      let s:baselistchars ..= s:displaychars[char]
    endif
  endfor
endfunction "}}}1

" Setup the Plugin
function whitespace#Setup() "{{{1
  highlight link TrailingSpace @comment.error
  call s:SetBaseListChars()

  augroup WhitespaceDisplay
    autocmd!
    autocmd InsertEnter * highlight clear TrailingSpace
    execute 'autocmd InsertLeave * highlight link TrailingSpace ' .. s:trailhlgroup
    autocmd WinNew,BufWinEnter,VimEnter * call s:SetupWindow()
    autocmd VimEnter * call s:SetupAllWindows()
    autocmd OptionSet buftype,filetype,shiftwidth call s:SetupWindow()
  augroup END

  command! Trim %s/\s\+$/
endfunction "}}}

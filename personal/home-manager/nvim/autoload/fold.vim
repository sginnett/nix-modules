" -----------------------Pretty Foldtext ---------------------------------------
"
"  A micro plugin for pretty folds in neovim displaying diagnostic and git
"  information.

" The main foldtext function
function! s:FoldText() "{{{
  let extra = "  (" .. (v:foldend - v:foldstart + 1) .. " lines)"
  let line = getline(v:foldstart)
  let text = []
  " Hack: Copy the highlight groups of the text in the first line of the fold to
  " preserve syntax highlighting.
  " TODO: may need modification for multi-byte characters
  for i in range(0, len(line)-1)
    call extend(text, [[ line[i] , s:GetHlGroups(v:foldstart-1, i) ]])
  endfor
  call extend(text, [[ extra, "ModeMsg" ]])
  call extend(text, s:FoldTextDiagnostics())
  call extend(text, s:FoldTextGit())
  return text
endfunction "}}}

" copy the highlight groups of a given character
function! s:GetHlGroups(line, col) "{{{
  let hl = []
  let data = v:lua.vim.inspect_pos(0, a:line, a:col)
  call extend(hl, map(data["syntax"], 'v:val["hl_group"]'))
  return hl
endfunction "}}}

" Determine diagnostics count within fold and return formatted foldtext showing
" the counts for each type.
function! s:FoldTextDiagnostics() "{{{
  let diagconfig = v:lua.vim.diagnostic.config()
  let icons = diagconfig.signs.text
  let hl = [ "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" ]
  let counts = [ 0, 0, 0, 0 ]
  let diags = v:lua.vim.diagnostic.get()
  for diag in diags
    if diag["lnum"] >= v:foldstart && diag["lnum"] <= v:foldend
      let counts[diag["severity"] - 1] += 1
    endif
  endfor
  let text = []
  for i in range(0, 3)
    if counts[i] > 0
      call extend(text, [[ " " .. counts[i] .. icons[i], hl[i] ]])
    endif
  endfor
  return text
endfunction "}}}

" Determine the line count of unstaged git hunks within the fold and return
" formatted foldtext displaying the counts
function! s:FoldTextGit() "{{{
  let icons = [ "~", "-", "+" ]
  let hls = [ "GitSignsChange", "GitSignsDelete", "GitSignsAdd" ]
  let counts = [ 0, 0, 0 ]
  let typeindex = {"add": 2, "change": 0, "delete": 1}
  let hunks = v:lua.require'gitsigns'.get_hunks()
  if empty(hunks)
    return []
  else
    for hunk in hunks
      let hunkend = hunk.added.start + hunk.added.count - 1
      if hunkend < v:foldstart || hunk.added.start > v:foldend
        continue
      else
        let id = typeindex[hunk.type]
        let linecount = max([v:foldstart, hunk.added.start]) - min([v:foldend, hunkend]) + 1
        let counts[id] += linecount
      endif
    endfor
  endif

  let text = []
  for i in range(0,3)
    if counts[i] > 0
      call extend(text, [[ " " .. icons[i] .. counts[i], hls[i] ]])
    endif
  endfor
  return text
endfunction "}}}

" Setup foldtext function and fillchars
function! fold#Setup() "{{{
  set foldtext=s:FoldText()
  " fill the remainder with spaces instead of dashes
  set fillchars+=fold:\ 
endfunction "}}}

" Micro plugin to highlight and delete trailing whitespace
function! s:SetupMatch()
  if !exists('w:trailspace_match_id')
    let w:trailspace_match_id = -1
  endif
  if &buftype != ""
    return s:DestroyMatch()
  endif
  if w:trailspace_match_id == -1
    let w:trailspace_match_id = matchadd('TrailingSpace', '\s\+$')
  endif
endfunction

function! s:DestroyMatch()
  if exists('w:trailspace_match_id') && w:trailspace_match_id != -1
    call matchdelete(w:trailspace_match_id)
    let w:trailspace_match_id = -1
  endif
endfunction

function! s:Toggle()
  if !exists('w:trailspace_match_id') || w:trailspace_match_id == -1
    call s:SetupMatch()
  else
    call s:DestroyMatch()
endfunction


function! trail_space#Setup()
  highlight link TrailingSpace @comment.error

  augroup TrailSpace
    autocmd!
    autocmd InsertEnter * highlight clear TrailingSpace
    autocmd InsertLeave * highlight link TrailingSpace @comment.error
    autocmd WinNew,VimEnter * call s:SetupMatch()
    autocmd OptionSet buftype call s:SetupMatch()
  augroup END

  command! Trim %s/\s\+$/
  command! TrailSpaceDisable call s:DestroyMatch()
  command! TrailSpaceEnable call s:SetupMatch()
  command! TrailSpaceToggle call s:Toggle()
endfunction

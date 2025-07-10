function! autocmd_debugger#Setup()
  if !exists('g:autocmd_debugger_events')
    let g:autocmd_debugger_events = []
  endif
  augroup AutocmdDebugger
    autocmd!
    for cmd in g:autocmd_debugger_events
      execute 'autocmd ' .. cmd .. ' * call autocmd_debugger#Notify("' .. cmd .. '")'
    endfor
  augroup END
endfunction

function! autocmd_debugger#Notify(cmdname)
  let acmess = "Autocmd triggered: " .. a:cmdname .. "\n v:event: " .. string(v:event)
  let acmess ..= "\n afile: " .. expand("<afile>")
  let acmess ..= "\n amatch: " .. expand("<amatch>")
  let acmess ..= "\n abuf: " .. expand("<abuf>")
  let acmess ..= "\n abufname: " .. bufname(expand("<abuf>"))
  let acmess ..= "\n abufwinid: " .. bufwinid(expand("<abuf>"))
  let acmess ..= "\n %: " .. bufname("%")
  let acmess ..= "\n curbuf: " .. bufnr("%")
  let acmess ..= "\n winid: " .. bufwinid("%")
  let acmess ..= "\n buftype: " .. &buftype
  let acmess ..= "\n filetype: " .. &filetype
  call v:lua.vim.notify(acmess)
endfunction

function! autocmd_debugger#Monitor(cmdname)
  if !exists('g:autocmd_debugger_events')
    let g:autocmd_debugger_events = []
  endif
  call extend(g:autocmd_debugger_events, [a:cmdname])
  call autocmd_debugger#Setup()
endfunction

function! autocmd_debugger#Clear()
  let g:autocmd_debugger_events = []
  call autocmd_debugger#Setup()
endfunction

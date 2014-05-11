if exists('g:loaded_forward')
  finish
endif

if !exists('g:forward_add_mappings')
    let g:forward_add_mappings = 1
endif

if !exists('g:forward_blink_time')
    let g:forward_blink_time=0
endif

function! s:HighlightSearch()
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#'.@/
    let ring = matchadd('IncSearch', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(g:forward_blink_time) . 'm'
    call matchdelete(ring)
    redraw
endfunction

function! s:SaveAction(action)
    let s:last_fFtTaction = a:action
endfunction

function! s:WasLastActionForward()
    if exists('s:last_fFtTaction')
        return match(s:last_fFtTaction, '[ft]') > -1
    else
        return 1
    endif
endfunction

noremap <silent>        <Plug>(ForwardHighlightSearch)          :call <SID>HighlightSearch()<cr>
noremap <silent> <expr> <Plug>(ForwardSearchForward)            (v:searchforward ? "n" : "N")
noremap <silent> <expr> <Plug>(ForwardSearchBackward)           (v:searchforward ? "N" : "n")

noremap <silent>        <Plug>(ForwardSavef)          :call <SID>SaveAction('f')<CR>
noremap <silent>        <Plug>(ForwardSaveF)          :call <SID>SaveAction('F')<CR>
noremap <silent>        <Plug>(ForwardSavet)          :call <SID>SaveAction('t')<CR>
noremap <silent>        <Plug>(ForwardSaveT)          :call <SID>SaveAction('T')<CR>
noremap <silent>        <Plug>(Forwardf)              :call <SID>SaveAction('f')<CR>f
noremap <silent>        <Plug>(ForwardF)              :call <SID>SaveAction('F')<CR>F
noremap <silent>        <Plug>(Forwardt)              :call <SID>SaveAction('t')<CR>t
noremap <silent>        <Plug>(ForwardT)              :call <SID>SaveAction('T')<CR>T
noremap <silent> <expr> <Plug>(ForwardRepeatForward)  (<SID>WasLastActionForward() ? ';' : ',')
noremap <silent> <expr> <Plug>(ForwardRepeatBackward) (<SID>WasLastActionForward() ? ',' : ';')

if g:forward_add_mappings
    if g:forward_blink_time > 0
        nmap n <Plug>(ForwardSearchForward)<Plug>(ForwardHighlightSearch)
        nmap N <Plug>(ForwardSearchBackward)<Plug>(ForwardHighlightSearch)
    else
        nmap n <Plug>(ForwardSearchForward)
        nmap N <Plug>(ForwardSearchBackward)
    endif

    map f <Plug>(Forwardf)
    map F <Plug>(ForwardF)
    map t <Plug>(Forwardt)
    map T <Plug>(ForwardT)
    map ; <Plug>(ForwardRepeatForward)
    map , <Plug>(ForwardRepeatBackward)
endif

" Not grep, but something similar.

" To use with ack [ http://betterthangrep.com/ ]
function! s:NotGrepUseAck()
    let g:notgrep_prg="ack -H --nocolor --nogroup --column"
    let g:notgrep_efm = "%f:%l:%c:%m"
endfunction

" To use with csearch [ https://code.google.com/p/codesearch/ ]
function! s:NotGrepUseCsearch()
    let g:notgrep_prg='csearch -n'
    let g:notgrep_efm = "%f:%l:%m"
endfunction

" Setup ack as a default
if !exists('g:notgrep_prg') || !exists("g:notgrep_efm")
    call s:NotGrepUseAck()
endif

function! s:NotGrep(cmd, args)
    redraw
    echo "Searching ..."

    " If no pattern is provided, search for the word under the cursor
    if empty(a:args)
        let l:grepargs = expand("<cword>")
    else
        let l:grepargs = a:args
    end

    " Format, used to manage column jump
    if a:cmd =~# '-g$'
        let l:grepformat = "%f"
    else
        let l:grepformat = g:notgrep_efm
    end

    let grepprg_bak = &grepprg
    let grepformat_bak = &grepformat
    try
        let &grepprg = g:notgrep_prg
        let &grepformat = l:grepformat
        silent execute a:cmd . " " . l:grepargs
    finally
        let &grepprg = grepprg_bak
        let &grepformat = grepformat_bak
    endtry

    if a:cmd =~# '^l'
        botright lopen
    else
        botright copen
    endif

    if !exists("g:notgrep_no_mappings") || !g:notgrep_no_mappings
        exec "nnoremap <silent> <buffer> q :ccl<CR>"
        exec "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
        exec "nnoremap <silent> <buffer> T <C-W><CR><C-W>TgT<C-W><C-W>"
        exec "nnoremap <silent> <buffer> o <CR>"
        exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"
        exec "nnoremap <silent> <buffer> v <C-W><C-W><C-W>v<C-L><C-W><C-J><CR>"
        exec "nnoremap <silent> <buffer> gv <C-W><C-W><C-W>v<C-L><C-W><C-J><CR><C-W><C-J>"
    endif


    " If highlighting is on, highlight the search keyword.
    if exists("g:notgrep_highlight")
        let @/=a:args
        set hlsearch
    end

    redraw!
endfunction

function! s:NotGrepFromSearch(cmd, args)
    let search =  getreg('/')
    " translate vim regular expression to perl regular expression.
    let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
    call s:NotGrep(a:cmd, '"' .  search .'" '. a:args)
endfunction

command! -bang -nargs=* -complete=file NotGrep call s:NotGrep('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file NotGrepAdd call s:NotGrep('grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file NotGrepFromSearch call s:NotGrepFromSearch('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LNotGrep call s:NotGrep('lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LNotGrepAdd call s:NotGrep('lgrepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file NotGrepFile call s:NotGrep('grep<bang> -g', <q-args>)
command! -nargs=0 NotGrepUseAck call s:NotGrepUseAck()
command! -nargs=0 NotGrepUseCsearch call s:NotGrepUseCsearch()

" vi: et sw=4 ts=4

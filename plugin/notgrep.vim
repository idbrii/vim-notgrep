" Not grep, but something similar.

if exists("g:notgrep_loaded")
    finish
endif
let g:notgrep_loaded = 1

let g:notgrep_allow_async = get(g:, 'notgrep_allow_async', 1)
let g:notgrep_allow_shellescape = get(g:, 'notgrep_allow_shellescape', 1)

" Disable so you can use symlinks to work around inability of passing paths
" containing spaces to ripgrep.
let g:notgrep_resolve_paths = get(g:, 'notgrep_resolve_paths', 1)

" Setup ack as a default
if !exists('g:notgrep_prg') || !exists("g:notgrep_efm")
    call notgrep#setup#NotGrepUseAck()
endif

command! -bang -nargs=* -complete=file NotGrep call notgrep#search#NotGrep('grep<bang>',<q-args>, '')
command! -bang -nargs=* -complete=file NotGrepAdd call notgrep#search#NotGrep('grepadd<bang>', <q-args>, '')
command! -bang -nargs=* -complete=file NotGrepFromSearch call notgrep#search#NotGrepFromSearch('grep<bang>', '')
command! -bang -nargs=* -complete=file LNotGrep call notgrep#search#NotGrep('lgrep<bang>', <q-args>, '')
command! -bang -nargs=* -complete=file LNotGrepAdd call notgrep#search#NotGrep('lgrepadd<bang>', <q-args>, '')
command! -bang -nargs=* -complete=file NotGrepFile call notgrep#search#NotGrep('grep<bang> -g', <q-args>, '')
command! -nargs=0 NotGrepUseAck call notgrep#setup#NotGrepUseAck()
command! -nargs=0 NotGrepUseCsearch call notgrep#setup#NotGrepUseCsearch()
command! -nargs=0 NotGrepUseRipgrep call notgrep#setup#NotGrepUseRipgrep()
command! -nargs=1 -complete=dir NotGrepRecursiveFrom call notgrep#setup#NotGrepRecursiveFrom(<f-args>)
" 'UseGrep' means it uses grepprg.
command! -nargs=1 -complete=dir NotGrepUseGrepRecursiveFrom call notgrep#setup#NotGrepUseGrepRecursiveFrom(<f-args>)

" vi: et sw=4 ts=4

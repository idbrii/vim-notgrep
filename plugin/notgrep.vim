" Not grep, but something similar.

" Setup ack as a default
if !exists('g:notgrep_prg') || !exists("g:notgrep_efm")
    call notgrep#setup#NotGrepUseAck()
endif

command! -bang -nargs=* -complete=file NotGrep call notgrep#search#NotGrep('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file NotGrepAdd call notgrep#search#NotGrep('grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file NotGrepFromSearch call notgrep#search#NotGrepFromSearch('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LNotGrep call notgrep#search#NotGrep('lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LNotGrepAdd call notgrep#search#NotGrep('lgrepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file NotGrepFile call notgrep#search#NotGrep('grep<bang> -g', <q-args>)
command! -nargs=0 NotGrepUseAck call notgrep#setup#NotGrepUseAck()
command! -nargs=0 NotGrepUseCsearch call notgrep#setup#NotGrepUseCsearch()

" vi: et sw=4 ts=4

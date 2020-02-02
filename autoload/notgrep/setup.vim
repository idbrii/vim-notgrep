" Not grep, but something similar.
"
" Functions called for initialization or configuration.

" To use with ack [ http://betterthangrep.com/ ]
function! notgrep#setup#NotGrepUseAck()
    let g:notgrep_prg="ack -H --nocolor --nogroup --column"
    let g:notgrep_efm = "%f:%l:%c:%m"
endfunction

" To use with csearch [ https://code.google.com/p/codesearch/ ]
function! notgrep#setup#NotGrepUseCsearch()
    let g:notgrep_prg='csearch -n'
    let g:notgrep_efm = "%f:%l:%m"
endfunction

" To use with grep
function! notgrep#setup#NotGrepUseGrepRecursiveFrom(root_dir)
    " &grepprg default on unix is `grep -n $* /dev/null` which can't be
    " appended to, so strip off everything after $*. That should keep
    " desirable flags, but allow us to put our own args and recursive flag.
    let prg = substitute(&grepprg, '\V$*\v.*', '', '')
    let g:notgrep_prg = prg .' $* -R '. resolve(fnamemodify(expand(a:root_dir), ':p'))
    let g:notgrep_efm = "%f:%l:%m"
endfunction

" vi: et sw=4 ts=4

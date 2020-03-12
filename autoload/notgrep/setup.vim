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
    if a:root_dir =~# '^g:\w'
        " If passed a variable, use its value.
        let root_dir = get(g:, a:root_dir[2:], '')
    else
        let root_dir = a:root_dir
    endif

    let root_dir = expand(root_dir)
    if !isdirectory(root_dir)
        echohl WarningMsg
        echomsg 'Failed to find directory: '. a:root_dir
        echohl None
        return
    endif

    " &grepprg default on unix is `grep -n $* /dev/null` which can't be
    " appended to, so strip off everything after $*. That should keep
    " desirable flags, but allow us to put our own args and recursive flag.
    let prg = substitute(&grepprg, '\V$*\v.*', '', '')
    let g:notgrep_prg = prg .' $* -R '. resolve(fnamemodify(root_dir, ':p'))
    let g:notgrep_efm = "%f:%l:%m"
endfunction

" vi: et sw=4 ts=4

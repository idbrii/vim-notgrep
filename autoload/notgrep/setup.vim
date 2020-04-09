" Not grep, but something similar.
"
" Functions called for initialization or configuration.

" To use with ack [ http://betterthangrep.com/ ]
function! notgrep#setup#NotGrepUseAck()
    let g:notgrep_prg="ack -H --nocolor --nogroup --column"
    let g:notgrep_efm = "%f:%l:%c:%m"
endfunction

" To use with ripgrep [ https://github.com/BurntSushi/ripgrep ]
function! notgrep#setup#NotGrepUseRipgrep()
    let g:notgrep_prg='rg --vimgrep'
    let g:notgrep_efm = "%f:%l:%c:%m"
endfunction

" To use with csearch [ https://code.google.com/p/codesearch/ ]
function! notgrep#setup#NotGrepUseCsearch()
    let g:notgrep_prg='csearch -n'
    let g:notgrep_efm = "%f:%l:%m"
endfunction

" Recursive search with whatever grepprg you're using.
function! notgrep#setup#NotGrepUseGrepRecursiveFrom(root_dir)
    let g:notgrep_prg = &grepprg
    let g:notgrep_efm = &grepformat
    return notgrep#setup#NotGrepRecursiveFrom(a:root_dir)
endfunction

" Use grepprg recursively from a directory. Call an above setup function to
" set the command and efm.
function! notgrep#setup#NotGrepRecursiveFrom(root_dir)
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
    let prg = substitute(g:notgrep_prg, '\V$*\v.*', '', '')
    let recursive_flag = ''
    " POSIX grep needs -R to be recursive, but replacements tend to be
    " recursive by default. smartgrep is a grep wrapper from vim-searchsavvy.
    if &grepprg =~# '\v<(smart)?grep>'
        let recursive_flag = '-R'
    endif
    let g:notgrep_prg = printf('%s $* %s %s', prg, recursive_flag, resolve(fnamemodify(root_dir, ':p')))
endfunction

" vi: et sw=4 ts=4

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
    let g:notgrep_prg = 'rg --vimgrep'
    if &smartcase
        let g:notgrep_prg .= ' --smart-case'
    elseif &ignorecase
        let g:notgrep_prg .= ' --ignore-case'
    endif
    let g:notgrep_efm = "%f:%l:%c:%m"
    " Ripgrep is automatically recursive, but includes a --type argument to
    " limit which files are searched.
    command! -bang -nargs=* -complete=file NotGrepCurrentFiletype           call notgrep#search#NotGrep('grep<bang>', <q-args>, '--type '.. &filetype)
    command! -bang -nargs=0                NotGrepCurrentFiletypeFromSearch call notgrep#search#NotGrepFromSearch('grep<bang>', '--type '.. &filetype)
endfunction

" To use with csearch [ https://github.com/junkblocker/codesearch ]
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

function! s:expand_directory(directory)
    let directory = expand(a:directory)
    if !isdirectory(directory)
        return ''
    endif
    let directory = fnamemodify(directory, ':p')
    if g:notgrep_resolve_paths
        let directory = resolve(directory)
    endif
    return directory
endf

function! s:warning(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None
endf

" Use grepprg recursively from a directory. Call an above setup function to
" set the command and efm.
function! notgrep#setup#NotGrepRecursiveFrom(root_dirs)
    if type(a:root_dirs) == v:t_string && a:root_dirs =~# '^g:\w'
        " If passed a variable, use its value.
        let root_dirs = get(g:, a:root_dirs[2:], '')
    else
        let root_dirs = a:root_dirs
    endif

    let root_dir_expanded = ''
    if type(root_dirs) == v:t_list
        for d in root_dirs
            let directory = s:expand_directory(d)
            if empty(directory)
                call s:warning('NotGrepRecursiveFrom: Failed to find input directory: '. d)
                return
            endif
            let root_dir_expanded .= directory . ' '
        endfor
    else
        let root_dir_expanded = s:expand_directory(root_dirs)
        if empty(root_dir_expanded)
            call s:warning('NotGrepRecursiveFrom: Failed to find input directory: '. root_dirs)
            return
        endif
    endif

    " &grepprg default on unix is `grep -n $* /dev/null` which can't be
    " appended to, so strip off everything after $*. That should keep
    " desirable flags, but allow us to put our own args and recursive flag.
    let prg = substitute(g:notgrep_prg, '\V$*\v.*', '', '')
    let recursive_flag = ''
    " POSIX grep needs -R to be recursive, but replacements tend to be
    " recursive by default. smartgrep is a grep wrapper from vim-searchsavvy.
    if g:notgrep_prg =~# '\v<(smart)?grep>'
        let recursive_flag = '-R'
    endif
    if prg =~# '\v<(smart)?grep> -nH$'
        " Use extended regex because it makes grep parse more like ripgrep
        " which is easier to translate to.
        let prg .= 'E'
    endif
    let g:notgrep_prg = printf('%s $* %s %s', prg, recursive_flag, root_dir_expanded)
endfunction

" vi: et sw=4 ts=4

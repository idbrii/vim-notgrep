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
    let g:notgrep_prg = &grepprg .' $* -R '. resolve(fnamemodify(expand(a:root_dir), ':p'))
    let g:notgrep_efm = "%f:%l:%m"
endfunction

" vi: et sw=4 ts=4

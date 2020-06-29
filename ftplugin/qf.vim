
if !exists("g:notgrep_no_mappings") || !g:notgrep_no_mappings
    nnoremap <silent> <buffer> q :ccl<CR>
    nnoremap <silent> <buffer> t <C-W><CR><C-W>T
    nnoremap <silent> <buffer> T <C-W><CR><C-W>TgT<C-W><C-W>
    nnoremap <silent> <buffer> o <CR>
    nnoremap <silent> <buffer> go <CR><C-W><C-W>
    nnoremap <silent> <buffer> v <C-W><C-W><C-W>v<C-L><C-W><C-J><CR>
    nnoremap <silent> <buffer> gv <C-W><C-W><C-W>v<C-L><C-W><C-J><CR><C-W><C-J>
endif

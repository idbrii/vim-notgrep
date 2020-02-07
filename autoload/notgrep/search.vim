" Not grep, but something similar.
"
" Search and core plugin implementation.

function! notgrep#search#NotGrep(cmd, args)
    " Use AsyncCommand's :AsyncGrep if possible.
    " Only grep is replaceable with async grep. Others do vim-specific stuff.
    let use_asyncgrep = g:notgrep_allow_async && exists(':AsyncGrep') == 2 && a:cmd == 'grep'

    " If no pattern is provided, search for the word under the cursor
    if empty(a:args)
        let l:grepargs = expand("<cword>")
    else
        let l:grepargs = a:args
    end

    " Separately store requested query and escaped version for grep.
    let l:query = l:grepargs
    let l:grepargs = shellescape(l:grepargs)

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
        if use_asyncgrep
            execute "AsyncGrep " . l:grepargs
        else
            " Silent to hide cmd window on windows and cmdline vim.
            silent execute a:cmd . " " . l:grepargs
        endif
    finally
        let &grepprg = grepprg_bak
        let &grepformat = grepformat_bak
    endtry

    " AsyncGrep will open it when it completes.
    if !use_asyncgrep
        if a:cmd =~# '^l'
            botright lopen
        else
            botright copen
        endif
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
        let @/ = notgrep#search#ConvertRegexPerlToVim(l:query)
        set hlsearch
    end

    redraw!
    echo "Searching ..."
endfunction

function! notgrep#search#ConvertRegexVimToPerl(vim_regex)
    " Translate vim regular expression to perl regular expression (what grep
    " uses). Only a partial translation. See perl-patterns for more details.
    let search = a:vim_regex
    let search = substitute(search, '\C\\v', '', 'g')
    let was_verymagic = len(search) < len(a:vim_regex)

    let escape = '\\'
    let unescape = ''
    if was_verymagic
        " verymagic flips escaping rules
        let escape = ''
        let unescape = '\\'
    endif

    " Some funky scripting for notgrep_prg may not handle spaces (using xargs
    " to grep a list of files).
    if exists("g:notgrep_replace_space_with_dot") && g:notgrep_replace_space_with_dot
        let search = substitute(search,' ','.','g')
    endif

    " Don't let the shell get confused by quotes.
    let search = substitute(search,"[\"']",'.','g')

    " Don't replace % or # with filename.
    let search = escape(search, "%#")

    " No easy support for disabling regex so ignore
    let search = substitute(search,'\\V','','g')
    " PCRE word boundaries
    let search = substitute(search,'\('. escape .'<\|'. escape .'>\)','\\b','g')

    " PCRE character classes
    let character_classes = {
                \ 's' : '[[:space:]]',
                \ 'S' : '[^ \\t]',
                \ 'd' : '[[:digit:]]',
                \ 'D' : '[^0-9]',
                \ 'x' : '[[:xdigit:]]',
                \ 'X' : '[^0-9A-Fa-f]',
                \ 'o' : '[0-7]',
                \ 'O' : '[^0-7]',
                \ 'w' : '[0-9A-Za-z_]',
                \ 'W' : '[^0-9A-Za-z_]',
                \ 'h' : '[A-Za-z_]',
                \ 'H' : '[^A-Za-z_]',
                \ 'a' : '[[:alpha:]]',
                \ 'A' : '[^A-Za-z]',
                \ 'l' : '[[:lower:]]',
                \ 'L' : '[^a-z]',
                \ 'u' : '[[:upper:]]',
                \ 'U' : '[^A-Z]',
                \ }
    for vim_class in keys(character_classes)
        " case is very important!
        let search = substitute(search, '\C\\'. vim_class .'\>', character_classes[vim_class], 'g')
    endfor

    if was_verymagic
        " Always need to escape pipe in shell
        let search = substitute(search, '|','\\|','g')
    else
        " PCRE operates a bit like verymagic, so remove some escaping

        " Dot regular unescaped parens
        let search = substitute(search, '\v(\\)@<![()]','.','g')
        " Remove escape from escaped capture parens
        let search = substitute(search, '\v\\([()])','\1','g')

        " Unescape some multis
        let search = substitute(search,'\v\\([+=?])','\1','g')
    endif
    return search
endfunction

function! notgrep#search#ConvertRegexPerlToVim(perl_regex)
    " Translate perl regular expression to vim regular expression.
    let search = a:perl_regex
    let search = substitute(search,'\\b','','g')
    return search
endfunction

function! notgrep#search#NotGrepFromSearch(cmd)
    let vim_search = getreg('/')
    let search = notgrep#search#ConvertRegexVimToPerl(vim_search)
    call notgrep#search#NotGrep(a:cmd, search)

    " The conversion is lossy, so keep our original query.
    let @/=vim_search
endfunction

" vi: et sw=4 ts=4

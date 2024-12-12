let s:fzf_mru_exclude = [
            \ '^/usr/',
            \ '^/opt/',
            \ '^/etc/',
            \ '^/var/',
            \ '^/tmp/',
            \ '^/private/',
            \ '\.git/',
            \ '/\?\.gems/',
            \ '\.vim/plugged/',
            \ '\.fugitiveblame$',
            \ 'COMMIT_EDITMSG$',
            \ 'git-rebase-todo$',
            \ ]

function! clap_settings#mru#filter(path) abort
    for l:pattern in s:clap_mru_exclude
        if a:path =~ l:pattern
            return 0
        endif
    endfor
    return 1
endfunction

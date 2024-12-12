function! clap_settings#files#run(dir, ...) abort
    try
        let l:cwd = getcwd()
        let l:dir = fnamemodify(empty(a:dir) ? '.' : a:dir, ':p:h')
        let l:bang = get(a:, 1, 0)
        execute 'lcd' l:dir
        execute 'Clap! files' (l:bang ? '--name-only' : '')
    finally
        execute 'lcd' l:cwd
    endtry
endfunction

function! clap_settings#files#git(dir, ...) abort
    try
        let l:cwd = getcwd()
        let l:dir = fnamemodify(empty(a:dir) ? '.' : a:dir, ':p:h')
        let l:bang = get(a:, 1, 0)
        let g:__clap_provider_cwd = l:dir
        execute 'lcd' l:dir
        execute printf('%s git_ls_files', l:bang ? 'Clap!' : 'Clap')
    finally
        execute 'lcd' l:cwd
    endtry
endfunction

function! clap_settings#files#myfiles(dir, ...) abort
    try
        let l:cwd = getcwd()
        let l:dir = fnamemodify(empty(a:dir) ? '.' : a:dir, ':p:h')
        let l:bang = get(a:, 1, 0)
        let g:__clap_provider_cwd = l:dir
        execute 'lcd' l:dir
        execute printf('%s myfiles', l:bang ? 'Clap!' : 'Clap')
    finally
        execute 'lcd' l:cwd
    endtry
endfunction

function! clap_settings#files#myallfiles(dir, ...) abort
    try
        let l:cwd = getcwd()
        let l:dir = fnamemodify(empty(a:dir) ? '.' : a:dir, ':p:h')
        let l:bang = get(a:, 1, 0)
        let g:__clap_provider_cwd = l:dir
        execute 'lcd' l:dir
        execute printf('%s myallfiles', l:bang ? 'Clap!' : 'Clap')
    finally
        execute 'lcd' l:cwd
    endtry
endfunction

function! clap_settings#files#ToggleFollowLinks() abort
    if g:clap_follow_links == 0
        let g:clap_follow_links = 1
        echo 'Clap follows symlinks!'
    else
        let g:clap_follow_links = 0
        echo 'Clap does not follow symlinks!'
    endif
    call clap_settings#command#Init()
endfunction

let s:clap_external_themes = [
            \ 'OceanicNext',
            \ 'OceanicNextLight',
            \ 'edge',
            \ 'everforest',
            \ 'gruvbox-material',
            \ 'nord',
            \ 'sonokai',
            \ ]

function! clap_settings#find_themes() abort
    let s:clap_themes = map(split(globpath(&rtp, 'autoload/clap/themes/*.vim')), "fnamemodify(v:val, ':t:r')")
    let s:clap_themes_completion = join(s:clap_themes, "\n")
endfunction

function! clap_settings#list_themes(...) abort
    return s:clap_themes_completion
endfunction

function! clap_settings#reinit_theme() abort
    call clap#highlighter#clear_display()
    call clap#themes#init()
endfunction

function! clap_settings#set_theme(theme) abort
    if index(s:clap_external_themes, a:theme) > -1
        unlet! g:clap_theme
        call clap_settings#reinit_theme()
        return
    endif

    if index(s:clap_themes, a:theme) < 0
        return
    endif

    " Reload theme palette
    let l:theme_path = findfile(printf('autoload/clap/themes/%s.vim', a:theme), &rtp)
    if !empty(l:theme_path) && filereadable(l:theme_path)
        " echomsg 'source ' . l:theme_path
        execute 'source ' . l:theme_path
    endif

    let g:clap_theme = a:theme
    call clap_settings#reinit_theme()
endfunction

function! clap_settings#build_theme() abort
    let l:original_theme = get(g:, 'colors_name', '')
    if has('vim_starting') && exists('g:clap_theme')
        let l:original_theme = g:clap_theme
    endif

    if l:original_theme =~ 'solarized\|soluarized\|flattened'
        let l:original_theme = 'solarized'
    endif

    let l:theme = l:original_theme

    if l:theme ==# 'gruvbox' || l:theme =~ 'gruvbox8'
        let l:theme = 'onehalfdark'
    endif

    if index(s:clap_themes, l:theme) < 0
        let l:theme = tolower(l:original_theme)
    endif

    if index(s:clap_themes, l:theme) < 0
        let l:theme = substitute(l:original_theme, '-', '_', 'g')
    endif

    if index(s:clap_themes, l:theme) < 0
        let l:theme = substitute(l:original_theme, '-', '', 'g')
    endif

    if index(s:clap_themes, l:theme) < 0
        let l:theme = l:original_theme
    endif

    return l:theme
endfunction

function! clap_settings#reload_theme() abort
    let l:theme = clap_settings#build_theme()
    call clap_settings#set_theme(l:theme)
endfunction

function! clap_settings#prompt_format() abort
    if g:clap.provider.id ==# 'files' && exists('g:__clap_provider_cwd')
        let cwd = fnamemodify(g:__clap_provider_cwd, ':~:.')
        if cwd[0] ==# '~' || cwd[0] ==# '/'
            let cwd = pathshorten(cwd)
        endif
        return g:clap_prompt_format . cwd . ' '
    endif
    return g:clap_prompt_format . ' '
endfunction

function! clap_settings#files(dir, bang) abort
    execute printf('%s files! ++finder=%s', a:bang ? 'Clap!' : 'Clap', g:clap_find_command) a:dir
endfunction

function! clap_settings#files_all(dir, bang) abort
    execute printf('%s files! ++finder=%s', a:bang ? 'Clap!' : 'Clap', g:clap_find_all_command) a:dir 
endfunction

let s:clap_mru_exclude = [
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

function! clap_settings#mru_filter(path) abort
    for l:pattern in s:clap_mru_exclude
        if a:path =~ l:pattern
            return 0
        endif
    endfor
    return 1
endfunction

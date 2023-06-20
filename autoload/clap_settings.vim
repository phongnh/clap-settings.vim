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

function! clap_settings#default_theme(...) abort
    if &background == 'dark'
        return get(a:, 1, 'onehalfdark')
    else
        return get(a:, 2, 'onehalflight')
    endif
endfunction

function! clap_settings#set_theme(theme) abort
    let l:theme = a:theme

    if index(s:clap_external_themes, l:theme) > -1
        unlet! g:clap_theme
        call clap_settings#reinit_theme()
        return
    endif

    if index(s:clap_themes, l:theme) < 0
        let l:theme = clap_settings#default_theme()
    endif

    " echomsg 'l:theme:' l:theme

    " Reload theme palette
    let l:theme_path = findfile(printf('autoload/clap/themes/%s.vim', l:theme), &rtp)
    if !empty(l:theme_path) && filereadable(l:theme_path)
        " echomsg 'source ' . l:theme_path
        execute 'source ' . l:theme_path
    endif

    let g:clap_theme = l:theme
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
        let l:theme = clap_settings#default_theme('onehalfdark', 'onehalflight')
    endif

    if l:theme ==# 'atom'
        let l:theme = 'atom_dark'
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

function! clap_settings#extract(group, what, gui_or_cterm) abort
    return synIDattr(synIDtrans(hlID(a:group)), a:what, a:gui_or_cterm)
endfunction

function! clap_settings#highlight_details(group) abort
    let name = synIDattr(synIDtrans(hlID(a:group)), 'name')
    let output = execute(printf('highlight %s', name))
    let result = {}
    for item in split(output, '\s\+')
        if match(item, '=') > 0
            let [attr, value] = split(item, '=')
            let result[attr] = value
        endif
    endfor
    return result
endfunction

function! clap_settings#link_highlight(to_group, from_group, ...) abort
    let result = clap_settings#highlight_details(a:from_group)
    let hl = []
    for attr in a:000
        let mappings = {}
        if type(attr) == type('')
            let mappings[attr] = attr
        elseif type(attr) == type({})
            call extend(mappings, attr)
        endif
        for [key, val] in items(mappings)
            if has_key(result, val)
                call add(hl, printf('%s=%s', key, result[val]))
            endif
        endfor
    endfor
    if len(hl)
        execute 'highlight! ' . a:to_group . ' ' . join(hl, ' ')
    endif
endfunction

function! clap_settings#apply_theme_patches(...) abort
    highlight! link ClapIndicator ClapInput
    let l:theme = get(a:, 1, '')
    if l:theme == 'nord'
        call clap_settings#link_highlight('ClapSpinner', 'ClapInput', 'ctermbg', 'guibg')
    endif
    " call clap_settings#link_highlight('ClapSymbol', 'ClapInput', 'ctermbg', 'guibg', { 'ctermfg': 'ctermbg', 'guifg': 'guibg' })
endfunction

function! clap_settings#reload_theme() abort
    let l:theme = clap_settings#build_theme()
    call clap_settings#set_theme(l:theme)
    call clap_settings#apply_theme_patches(l:theme)
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

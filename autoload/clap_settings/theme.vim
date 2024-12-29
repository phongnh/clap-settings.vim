" Theme mappings
let s:clap_theme_mappings = extend({
            \ '^\(solarized\|soluarized\|flattened\|neosolarized\)': 'solarized8',
            \ '^\(atom\|habamax\)$': 'atom_dark',
            \ }, get(g:, 'clap_theme_mappings', {}))

function! s:ClearHighlightGroups() abort
    let l:highlight_groups = [
                \ 'ClapFile',
                \ 'ClapSpinner',
                \ 'ClapSearchText',
                \ 'ClapInput',
                \ 'ClapDisplay',
                \ 'ClapIndicator',
                \ 'ClapSelected',
                \ 'ClapCurrentSelection',
                \ 'ClapSelectedSign',
                \ 'ClapCurrentSelectionSign',
                \ 'ClapPreview',
                \ ]
    for l:group in l:highlight_groups
        if hlexists(l:group)
            execute 'highlight clear' l:group
        endif
    endfor
endfunction

function! s:RefreshTheme() abort
    call s:ClearHighlightGroups()
    if exists('g:clap')
        call clap#highlighter#clear_display()
    endif
    call clap#themes#init()
endfunction

function! s:ApplyPatches(...) abort
    highlight! link ClapIndicator ClapInput
endfunction

function! s:LoadTheme() abort
    if !exists('s:clap_themes')
        let s:clap_themes = map(split(globpath(&rtp, 'autoload/clap/themes/*.vim')), "fnamemodify(v:val, ':t:r')")
    endif
endfunction

function! s:FindTheme() abort
    let g:clap_current_theme = substitute(get(g:, 'colors_name', 'default'), '[ -]', '_', 'g')
    if index(s:clap_themes, g:clap_current_theme) > -1
        return
    endif

    let l:clap_theme = g:clap_current_theme . (&background == 'light' ? '_light' : '_dark')
    if index(s:clap_themes, l:clap_theme) > -1
        let g:clap_current_theme = l:clap_theme
        return
    endif

    for [l:pattern, l:theme] in items(s:clap_theme_mappings)
        if match(g:clap_current_theme, l:pattern) > -1 && index(s:clap_themes, l:theme) > -1
            let g:clap_current_theme = l:theme
            return
        endif
    endfor

    let g:clap_current_theme = 'default'
endfunction

function! clap_settings#theme#List(...) abort
    return join(s:clap_themes, "\n")
endfunction

function! clap_settings#theme#Set(theme) abort
    let l:theme = a:theme

    if index(s:clap_themes, l:theme) < 0
        " Default theme
        let l:theme = &background == 'light' ? 'onehalflight' : 'onehalfdark'
    endif

    " Reload theme palette
    let l:theme_path = findfile(printf('autoload/clap/themes/%s.vim', l:theme), &rtp)
    if !empty(l:theme_path) && filereadable(l:theme_path)
        execute 'source ' . l:theme_path
    endif
    let g:clap_theme = l:theme
    call s:RefreshTheme()
    call s:ApplyPatches()
    unlet! g:clap_theme
endfunction

function! clap_settings#theme#Apply() abort
    call s:LoadTheme()
    call s:FindTheme()
    call clap_settings#theme#Set(g:clap_current_theme)
endfunction

function! clap_settings#theme#Init() abort
    if has('vim_starting')
        call s:LoadTheme()
        call s:FindTheme()
        if g:clap_current_theme !=# 'default'
            call clap_settings#theme#Set(g:clap_current_theme)
        endif
    elseif !exists('g:clap_current_theme')
        call clap_settings#theme#Apply()
    endif
endfunction

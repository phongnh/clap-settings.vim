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
    try
        let l:cwd = getcwd()
        execute 'lcd' empty(a:dir) ? '.' : a:dir
        execute 'Clap! files' (a:bang ? '--name-only' : '')
    finally
        execute 'lcd' l:cwd
    endtry
endfunction

function! clap_settings#files_all(dir, bang) abort
    try
        let l:cwd = getcwd()
        execute 'lcd' empty(a:dir) ? '.' : a:dir
        execute 'Clap! files' (a:bang ? '--name-only' : '')
    finally
        execute 'lcd' l:cwd
    endtry
endfunction

function! clap_settings#ClearHighlightGroups() abort
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

function! clap_settings#RefreshTheme() abort
    call clap_settings#ClearHighlightGroups()
    if exists('g:clap')
        call clap#highlighter#clear_display()
    endif
    call clap#themes#init()
endfunction

function! clap_settings#ToggleFollowLinks() abort
    if g:clap_follow_links == 0
        let g:clap_follow_links = 1
        echo 'Clap follows symlinks!'
    else
        let g:clap_follow_links = 0
        echo 'Clap does not follow symlinks!'
    endif
    call clap_settings#command#Init()
endfunction

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

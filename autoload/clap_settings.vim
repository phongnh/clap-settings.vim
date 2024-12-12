let s:file_providers = [
            \ 'files',
            \ 'git_files',
            \ 'gfiles',
            \ 'git_ls_files',
            \ 'myfiles',
            \ 'myallfiles',
            \ ]

function! clap_settings#prompt_format() abort
    if index(s:file_providers, g:clap.provider.id) > -1 && exists('g:__clap_provider_cwd')
        let cwd = fnamemodify(g:__clap_provider_cwd, ':~:.')
        if cwd[0] ==# '~' || cwd[0] ==# '/'
            let cwd = pathshorten(cwd)
        endif
        return g:clap_prompt_format . cwd . ' '
    endif
    return g:clap_prompt_format . ' '
endfunction

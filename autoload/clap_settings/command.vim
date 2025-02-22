function! s:BuildFindCommand() abort
    if executable('fd')
        let g:clap_find_command = 'fd --base-directory %s --type file --color never --hidden'
        let g:clap_find_command .= (g:clap_follow_links ? ' --follow' : '')
        let g:clap_find_command .= (g:clap_find_no_ignore_vcs ? ' --no-ignore-vcs' : '')
    elseif executable('rg')
        let g:clap_find_command = 'rg %s --files --color never --ignore-dot --ignore-parent --hidden'
        let g:clap_find_command .= (g:clap_follow_links ? ' --follow' : '')
        let g:clap_find_command .= (g:clap_find_no_ignore_vcs ? ' --no-ignore-vcs' : '')
    endif
endfunction

function! s:BuildFindAllCommand() abort
    if executable('fd')
        let g:clap_find_all_command = 'fd --base-directory %s --type file --color never --no-ignore --exclude .git --hidden --follow'
    elseif executable('rg')
        let g:clap_find_all_command = 'rg %s --files --color never --no-ignore --exclude .git --hidden --follow'
    endif
endfunction

function! s:BuildGrepCommand() abort
    let g:clap_provider_live_grep_executable = 'rg'
    let g:clap_provider_live_grep_opts = '--color=never -H --no-heading --line-number --smart-case --hidden'
    let g:clap_provider_live_grep_opts .= g:clap_follow_links ? ' --follow' : ''
    let g:clap_provider_live_grep_opts .= g:clap_grep_no_ignore_vcs ? ' --no-ignore-vcs' : ''
endfunction

function! clap_settings#command#Init() abort
    call s:BuildFindCommand()
    call s:BuildFindAllCommand()
    call s:BuildGrepCommand()
endfunction

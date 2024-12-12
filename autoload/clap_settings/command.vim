function! s:BuildFindCommand() abort
    let l:find_commands = {
                \ 'fd': 'fd --type file --color never --hidden',
                \ 'rg': 'rg --files --color never --ignore-dot --ignore-parent --hidden',
                \ }
    let g:clap_find_command = l:find_commands[g:clap_find_tool ==# 'rg' ? 'rg' : 'fd']
    let g:clap_find_command .= (g:clap_follow_links ? ' --follow' : '')
    let g:clap_find_command .= (g:clap_find_no_ignore_vcs ? ' --no-ignore-vcs' : '')
    return g:clap_find_command
endfunction

function! s:BuildFindAllCommand() abort
    let l:find_all_commands = {
                \ 'fd': 'fd --type file --color never --no-ignore --exclude .git --hidden --follow',
                \ 'rg': 'rg --files --color never --no-ignore --exclude .git --hidden --follow',
                \ }
    let g:clap_find_all_command = l:find_all_commands[g:clap_find_tool ==# 'rg' ? 'rg' : 'fd']
    return g:clap_find_all_command
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

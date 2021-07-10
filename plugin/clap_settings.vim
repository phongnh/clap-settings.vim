if empty(globpath(&rtp, 'plugin/clap.vim'))
    echohl WarningMsg | echomsg 'clap.vim is not found.' | echohl none
    finish
endif

if exists('g:loaded_clap_settings_vim')
    finish
endif

if get(g:, 'clap_solarized_theme', 0)
    let g:clap_theme = 'solarized'

    call clap#themes#solarized#init()

    function! s:ReloadSolarizedTheme() abort
        call clap#themes#solarized#init()
        call clap#themes#init()
    endfunction

    augroup VimClapSolarizedTheme
        autocmd!
        autocmd Colorscheme * call <SID>ReloadSolarizedTheme()
    augroup END
endif

if get(g:, 'clap_enable_preview', 1)
    let g:clap_layout       = { 'relative': 'editor', 'width': '70%', 'height': '30%',  'row': '15%', 'col': '15%' }
    let g:clap_open_preview = 'always'
    let g:clap_preview_size = 3
else
    let g:clap_layout       = { 'relative': 'editor', 'width': '70%', 'height': '35%',  'row': '25%', 'col': '15%' }
    let g:clap_open_preview = 'never'
endif
let g:clap_popup_cursor_shape       = ''
let g:clap_preview_direction        = 'UD'
let g:clap_search_box_border_style  = 'nil'
let g:clap_enable_background_shadow = v:false
let g:clap_current_selection_sign   = { 'text': '» ', 'texthl': 'ClapCurrentSelectionSign', 'linehl': 'ClapCurrentSelection' }
let g:clap_selected_sign            = { 'text': ' »', 'texthl': 'ClapSelectedSign', 'linehl': 'ClapSelected' }
let g:clap_prompt_format            = ' %spinner%%forerunner_status%%provider_id%:'

let g:clap_insert_mode_only   = v:true
let g:clap_disable_run_rooter = v:true

let g:clap_file_root_markers = [
            \ 'Gemfile',
            \ 'rebar.config',
            \ 'mix.exs',
            \ 'Cargo.toml',
            \ 'shard.yml',
            \ 'go.mod'
            \ ]

let g:clap_root_markers = ['.git', '.hg', '.svn', '.bzr', '_darcs'] + g:clap_file_root_markers

let s:clap_ignored_root_dirs = [
            \ '/',
            \ '/root',
            \ '/Users',
            \ '/home',
            \ '/usr',
            \ '/usr/local',
            \ '/opt',
            \ '/etc',
            \ '/var',
            \ expand('~'),
            \ ]

function! ClapPromptFormat() abort
    if g:clap.provider.id ==# 'files' && exists('g:__clap_provider_cwd')
        let cwd = fnamemodify(g:__clap_provider_cwd, ':~:.')
        if cwd[0] ==# '~' || cwd[0] ==# '/'
            let cwd = pathshorten(cwd)
        endif
        return g:clap_prompt_format . cwd . ' '
    endif
    return g:clap_prompt_format . ' '
endfunction

let g:ClapPrompt = function('ClapPromptFormat')

if executable('rg')
    let g:clap_provider_grep_executable = 'rg'
    let g:clap_provider_grep_opts = '-H --no-heading --line-number --column --hidden --smart-case'

    if get(g:, 'clap_follow_links', 0)
        let g:clap_provider_grep_opts .= ' --follow'
    endif

    if get(g:, 'clap_grep_ignore_vcs', 0)
        let g:clap_provider_grep_opts .= ' --no-ignore-vcs'
    endif
endif

function! s:FindProjectDir(starting_dir) abort
    if empty(a:starting_dir)
        return ''
    endif

    let l:root_dir = ''

    for l:root_marker in g:clap_root_markers
        if index(g:clap_file_root_markers, l:root_marker) > -1
            let l:root_dir = findfile(l:root_marker, a:starting_dir . ';')
        else
            let l:root_dir = finddir(l:root_marker, a:starting_dir . ';')
        endif
        let l:root_dir = substitute(l:root_dir, l:root_marker . '$', '', '')

        if strlen(l:root_dir)
            let l:root_dir = fnamemodify(l:root_dir, ':p:h')
            break
        endif
    endfor

    if empty(l:root_dir) || index(s:clap_ignored_root_dirs, l:root_dir) > -1
        if index(s:clap_ignored_root_dirs, getcwd()) > -1
            let l:root_dir = a:starting_dir
        elseif stridx(a:starting_dir, getcwd()) == 0
            let l:root_dir = getcwd()
        else
            let l:root_dir = a:starting_dir
        endif
    endif

    return fnamemodify(l:root_dir, ':p:~')
endfunction

command! -bang ClapRoot execute (<bang>0 ? 'ClapFiles!' : 'ClapFiles') s:FindProjectDir(expand('%:p:h'))

let s:clap_available_commands = filter(['rg', 'fd'], 'executable(v:val)')

if empty(s:clap_available_commands)
    command! -bang -nargs=? -complete=dir ClapFiles execute printf('%s files +no-cache', <bang>0 ? 'Clap!' : 'Clap') <q-args>
    command! -bang -nargs=? -complete=dir ClapFilesAll ClapFiles<bang> <args>
    finish
endif

let g:clap_find_tool    = get(g:, 'clap_find_tool', 'rg')
let g:clap_follow_links = get(g:, 'clap_follow_links', 0)
let s:clap_follow_links = g:clap_follow_links
let g:clap_no_ignores   = get(g:, 'clap_no_ignores', 0)
let s:clap_no_ignores   = g:clap_no_ignores

let s:clap_find_commands = {
            \ 'rg': 'rg --files --color never --no-ignore-vcs --ignore-dot --ignore-parent --hidden',
            \ 'fd': 'fd --type file --color never --no-ignore-vcs --hidden',
            \ }

let s:clap_find_all_commands = {
            \ 'rg': 'rg --files --color never --no-ignore --hidden',
            \ 'fd': 'fd --type file --color never --no-ignore --hidden',
            \ }

function! s:BuildFindCommand() abort
    let l:cmd = s:clap_find_commands[s:clap_current_command]
    if s:clap_no_ignores
        let l:cmd = s:clap_find_all_commands[s:clap_current_command]
    endif
    if s:clap_follow_links == 1
        let l:cmd .= ' --follow'
    endif
    return l:cmd
endfunction

function! s:DetectClapCurrentCommand() abort
    let idx = index(s:clap_available_commands, g:clap_find_tool)
    let s:clap_current_command = get(s:clap_available_commands, idx > -1 ? idx : 0)
endfunction

function! s:BuildClapFinder() abort
    let s:clap_finder = s:BuildFindCommand()
endfunction

function! s:PrintClapCurrentCommandInfo() abort
    echo 'Clap is using command `' . s:clap_finder . '`!'
endfunction

command! PrintClapCurrentCommandInfo call <SID>PrintClapCurrentCommandInfo()

function! s:ChangeClapFinder(bang, command) abort
    " Reset to default command
    if a:bang
        call s:DetectClapCurrentCommand()
    elseif strlen(a:command)
        if index(s:clap_available_commands, a:command) == -1
            return
        endif
        let s:clap_current_command = a:command
    else
        let idx = index(s:clap_available_commands, s:clap_current_command)
        let s:clap_current_command = get(s:clap_available_commands, idx + 1, s:clap_available_commands[0])
    endif
    call s:BuildClapFinder()
    call s:PrintClapCurrentCommandInfo()
endfunction

function! s:ListClapAvailableCommands(...) abort
    return s:clap_available_commands
endfunction

command! -nargs=? -bang -complete=customlist,<SID>ListClapAvailableCommands ChangeClapFinder call <SID>ChangeClapFinder(<bang>0, <q-args>)

function! s:ToggleClapFollowLinks() abort
    if s:clap_follow_links == 0
        let s:clap_follow_links = 1
        echo 'Clap follows symlinks!'
    else
        let s:clap_follow_links = 0
        echo 'Clap does not follow symlinks!'
    endif
    call s:BuildClapFinder()
endfunction

command! ToggleClapFollowLinks call <SID>ToggleClapFollowLinks()

function! s:ToggleClapNoIgnores() abort
    if s:clap_no_ignores == 0
        let s:clap_no_ignores = 1
        echo 'Clap does not respect ignores!'
    else
        let s:clap_no_ignores = 0
        echo 'Clap respects ignores!'
    endif
    call s:BuildClapFinder()
endfunction

command! ToggleClapNoIgnores call <SID>ToggleClapNoIgnores()

function! s:ClapFilesAll(dir, bang) abort
    let current = s:clap_no_ignores
    try
        let s:clap_no_ignores = 1
        call s:BuildClapFinder()
        if a:bang
            execute 'ClapFiles!' a:dir
        else
            execute 'ClapFiles' a:dir
        endif
    finally
        let s:clap_no_ignores = current
        call s:BuildClapFinder()
    endtry
endfunction

command! -bang -nargs=? -complete=dir ClapFilesAll call <SID>ClapFilesAll(<q-args>, <bang>0)

command! -bang -nargs=? -complete=dir ClapFiles execute printf('%s files +no-cache ++finder=%s', <bang>0 ? 'Clap!' : 'Clap', s:clap_finder) <q-args>

call s:DetectClapCurrentCommand()
call s:BuildClapFinder()

let g:loaded_clap_settings_vim = 1

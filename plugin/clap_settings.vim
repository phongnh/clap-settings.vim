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

let g:clap_layout                   = { 'relative': 'editor', 'width': '65%', 'height': '50%',  'row': '20%', 'col': '15%' }
let g:clap_popup_cursor_shape       = ''
let g:clap_preview_direction        = 'UD'
let g:clap_search_box_border_style  = 'nil'
let g:clap_enable_background_shadow = v:false
let g:clap_current_selection_sign   = { 'text': '» ', 'texthl': 'ClapCurrentSelectionSign', 'linehl': 'ClapCurrentSelection' }
let g:clap_selected_sign            = { 'text': ' »', 'texthl': 'ClapSelectedSign', 'linehl': 'ClapSelected' }
let g:clap_prompt_format            = ' %spinner%%forerunner_status%%provider_id%:'

let g:clap_insert_mode_only   = v:true
let g:clap_disable_run_rooter = v:true

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
    if get(g:, 'clap_grep_ignore_vcs', 0)
        let g:clap_provider_grep_opts .= ' --no-ignore-vcs'
    endif
endif

function! s:ClapFindProjectDir(starting_path) abort
    if empty(a:starting_path)
        return ''
    endif

    for root_marker in ['.git', '.hg', '.svn']
        let root_dir = finddir(root_marker, a:starting_path . ';')
        if empty(root_dir)
            continue
        endif

        let root_dir = substitute(root_dir, root_marker, '', '')
        if !empty(root_dir)
            let root_dir = fnamemodify(root_dir, ':p:~:.')
        endif

        return root_dir
    endfor

    return ''
endfunction

command! -bang ClapRoot execute (<bang>0 ? 'ClapFiles!' : 'ClapFiles') s:ClapFindProjectDir(expand('%:p:h'))

let s:clap_available_commands = filter(['rg', 'fd'], 'executable(v:val)')

if empty(s:clap_available_commands)
    command! -bang -nargs=? -complete=dir ClapFiles execute printf('%s files +no-cache', <bang>0 ? 'Clap!' : 'Clap') <q-args>
    finish
endif

let g:clap_find_tool    = get(g:, 'clap_find_tool', 'rg')
let g:clap_follow_links = get(g:, 'clap_follow_links', 0)
let s:clap_follow_links = g:clap_follow_links

let s:clap_find_commands = {
            \ 'rg': 'rg --files --color never --no-ignore-vcs --ignore-dot --ignore-parent --hidden',
            \ 'fd': 'fd --type file --color never --no-ignore-vcs --hidden',
            \ }

function! s:BuildFindCommand() abort
    let l:cmd = s:clap_find_commands[s:clap_current_command]
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

command! -bang -nargs=? -complete=dir ClapFiles execute printf('%s files +no-cache ++finder=%s', <bang>0 ? 'Clap!' : 'Clap', s:clap_finder) <q-args>

call s:DetectClapCurrentCommand()
call s:BuildClapFinder()

let g:loaded_clap_settings_vim = 1

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
let g:clap_search_box_border_style  = 'nil'
let g:clap_enable_background_shadow = v:false
let g:clap_current_selection_sign   = { 'text': '» ', 'texthl': 'ClapCurrentSelectionSign', 'linehl': 'ClapCurrentSelection' }
let g:clap_selected_sign            = { 'text': ' »', 'texthl': 'ClapSelectedSign', 'linehl': 'ClapSelected' }
let g:clap_prompt_format            = ' %spinner%%forerunner_status%%provider_id%:'

let g:clap_insert_mode_only   = v:true
let g:clap_disable_run_rooter = v:true
let g:clap_grep_ignore_vcs    = get(g:, 'clap_grep_ignore_vcs', 0)

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
    let g:clap_provider_grep_opts = '-H --no-heading --hidden --vimgrep --smart-case' . (g:clap_grep_ignore_vcs ? ' --no-ignore-vcs' : '')
endif

let g:clap_find_tool    = get(g:, 'clap_find_tool', 'rg')
let g:clap_follow_links = get(g:, 'clap_follow_links', 0)
let s:clap_follow_links = g:clap_follow_links

let s:clap_find_tools = {
            \ 'rg': 'rg --color=never --no-ignore-vcs --ignore-dot --ignore-parent --hidden --files',
            \ 'fd': 'fd --color=never --no-ignore-vcs --hidden --type file',
            \ }

let s:clap_find_with_follows_tools = {
            \ 'rg': 'rg --color=never --no-ignore-vcs --ignore-dot --ignore-parent --hidden --follow --files',
            \ 'fd': 'fd --color=never --no-ignore-vcs --hidden --follow --type file',
            \ }

function! s:DetectClapAvailableFindTools() abort
    let s:clap_available_find_tools = []
    for cmd in ['rg', 'fd']
        if executable(cmd)
            call add(s:clap_available_find_tools, cmd)
        endif
    endfor
endfunction

call s:DetectClapAvailableFindTools()

function! s:SetupClapFindTool() abort
    let l:tools = s:clap_follow_links ? s:clap_find_with_follows_tools : s:clap_find_tools
    let idx = index(s:clap_available_find_tools, g:clap_find_tool)
    let cmd = get(s:clap_available_find_tools, idx > -1 ? idx : 0)
    let s:clap_find_tool = get(l:tools, cmd, '')
endfunction

function! s:SetupClapCommands() abort
    if strlen(s:clap_find_tool)
        command! -bang -nargs=? -complete=dir ClapFiles execute printf('%s files +no-cache ++finder=%s', <bang>0 ? 'Clap!' : 'Clap', s:clap_find_tool) <q-args>
    else
        command! -bang -nargs=? -complete=dir ClapFiles execute printf('%s files +no-cache', <bang>0 ? 'Clap!' : 'Clap') <q-args>
    endif
endfunction

call s:SetupClapFindTool()
call s:SetupClapCommands()

function! s:ToggleClapFollowLinks() abort
    if s:clap_follow_links == 0
        let s:clap_follow_links = 1
        echo 'Clap follows symlinks!'
    else
        let s:clap_follow_links = 0
        echo 'Clap does not follow symlinks!'
    endif
    call s:SetupClapFindTool()
endfunction

command! ToggleClapFollowLinks call <SID>ToggleClapFollowLinks()

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

let g:loaded_clap_settings_vim = 1

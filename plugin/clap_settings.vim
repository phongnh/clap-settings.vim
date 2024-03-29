if empty(globpath(&rtp, 'plugin/clap.vim'))
    echohl WarningMsg | echomsg 'clap.vim is not found.' | echohl none
    finish
endif

if exists('g:loaded_clap_settings_vim')
    finish
endif

let g:clap_open_preview = get(g:, 'clap_open_preview', 'always')

if g:clap_open_preview ==# 'never'
    let g:clap_layout = { 'relative': 'editor', 'width': '70%', 'height': '35%', 'row': '25%', 'col': '15%' }
else
    let g:clap_layout = { 'relative': 'editor', 'width': '70%', 'height': '30%', 'row': '15%', 'col': '15%' }
    let g:clap_preview_size = 3
    let g:clap_preview_direction = 'UD'
endif

let g:clap_search_box_border_style  = 'nil'
let g:clap_current_selection_sign   = { 'text': '» ', 'texthl': 'ClapCurrentSelectionSign', 'linehl': 'ClapCurrentSelection' }
let g:clap_selected_sign            = { 'text': ' »', 'texthl': 'ClapSelectedSign', 'linehl': 'ClapSelected' }
let g:clap_prompt_format            = ' %spinner%%forerunner_status%%provider_id%:'

let g:clap_insert_mode_only   = v:true
let g:clap_disable_run_rooter = v:true

let g:ClapPrompt                      = function('clap_settings#prompt_format')
let g:ClapProviderHistoryCustomFilter = function('clap_settings#mru_filter')

let g:clap_follow_links    = get(g:, 'clap_follow_links', 0)
let g:clap_grep_ignore_vcs = get(g:, 'clap_grep_ignore_vcs', 0)

function! s:build_grep_command() abort
    let g:clap_provider_live_grep_executable = 'rg'
    let g:clap_provider_live_grep_opts = '--color=never -H --no-heading --line-number --smart-case --hidden'
    let g:clap_provider_live_grep_opts .= g:clap_follow_links ? ' --follow' : ''
    let g:clap_provider_live_grep_opts .= g:clap_grep_ignore_vcs ? ' --no-ignore-vcs' : ''
endfunction

function! s:toggle_clap_live_grep_follow_links() abort
    if g:clap_follow_links == 0
        let g:clap_follow_links = 1
        echo 'Clap live_grep follows symlinks!'
    else
        let g:clap_follow_links = 0
        echo 'Clap live_grep does not follow symlinks!'
    endif
    call s:build_grep_command()
endfunction

command! -bang -nargs=? -complete=dir ClapFiles         call clap_settings#files(<q-args>, <bang>0)
command! -bang -nargs=? -complete=dir ClapFilesAll      call clap_settings#files_all(<q-args>, <bang>0)

command! ToggleClapLiveGrepFollowLinks call <SID>toggle_clap_live_grep_follow_links()

function! s:setup_clap_settings() abort
    call s:build_grep_command()
    call clap_settings#themes#init()
    call clap_settings#themes#reload()
endfunction

command! -nargs=1 -complete=custom,clap_settings#themes#list ClapThemeSet call clap_settings#themes#set(<q-args>)

augroup ClapSettings
    autocmd!
    autocmd VimEnter * call <SID>setup_clap_settings()
    autocmd ColorScheme * call clap_settings#themes#reload()
    autocmd FileType clap_input let [b:autopairs_enabled, b:lexima_disabled] = [0, 1]
augroup END

let g:loaded_clap_settings_vim = 1

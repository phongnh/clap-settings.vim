if empty(globpath(&rtp, 'plugin/clap.vim'))
    echohl WarningMsg | echomsg 'clap.vim is not found.' | echohl none
    finish
endif

if exists('g:loaded_clap_settings_vim')
    finish
endif

" let g:clap_cache_directory = expand('$HOME/.cache/vim/clap')

" Show devicons
let g:clap_enable_icon = get(g:, 'clap_enable_icon', 0)
" Always disable icon in live grep
let g:clap_provider_live_grep_enable_icon = 0

let g:clap_open_preview = get(g:, 'clap_open_preview', 'always')

if g:clap_open_preview ==# 'never'
    let g:clap_layout = { 'relative': 'editor', 'width': '70%', 'height': '40%', 'row': '25%', 'col': '20%' }
else
    let g:clap_layout = { 'relative': 'editor', 'width': '70%', 'height': '35%', 'row': '15%', 'col': '20%' }
    let g:clap_preview_direction = 'UD'
endif

let g:clap_search_box_border_style  = 'nil'
let g:clap_current_selection_sign   = { 'text': '» ', 'texthl': 'ClapCurrentSelectionSign', 'linehl': 'ClapCurrentSelection' }
let g:clap_selected_sign            = { 'text': ' »', 'texthl': 'ClapSelectedSign', 'linehl': 'ClapSelected' }
let g:clap_prompt_format            = ' %spinner%%forerunner_status%%title%:'

let g:clap_insert_mode_only   = v:true
let g:clap_disable_run_rooter = v:true

let g:ClapPrompt                      = function('clap_settings#prompt_format')
let g:ClapProviderHistoryCustomFilter = function('clap_settings#mru#filter')

" Root markers
let g:clap_project_root_markers = ['.git', '.git/', '.hg', '.svn', '.bzr', '_darcs'] + get(g:, 'clap_file_root_markers', [
            \ 'Gemfile',
            \ 'rebar.config',
            \ 'mix.exs',
            \ 'Cargo.toml',
            \ 'shard.yml',
            \ 'go.mod',
            \ '.root',
            \ ])

let g:clap_find_tool          = get(g:, 'clap_find_tool', 'fd')
let g:clap_find_no_ignore_vcs = get(g:, 'clap_find_no_ignore_vcs', 0)
let g:clap_follow_links       = get(g:, 'clap_follow_links', 0)
let g:clap_grep_no_ignore_vcs = get(g:, 'clap_grep_no_ignore_vcs', 0)

augroup ClapSettings
    autocmd!
    autocmd VimEnter * call clap_settings#command#Init() | call clap_settings#theme#Init()
    autocmd ColorScheme * call clap_settings#theme#Apply()
    autocmd FileType clap_input let [b:autopairs_enabled, b:lexima_disabled] = [0, 1]
augroup END

command! -nargs=1 -complete=custom,clap_settings#theme#List ClapTheme call clap_settings#theme#Set(<f-args>)

command! ToggleClapFollowLinks call clap_settings#files#ToggleFollowLinks()

command! -bang -nargs=? -complete=dir ClapFiles      call clap_settings#files#run(<q-args>, <bang>0)
command! -bang -nargs=? -complete=dir ClapGitFiles   call clap_settings#files#git(<q-args>, <bang>0)
command! -bang -nargs=? -complete=dir ClapMyFiles    call clap_settings#files#myfiles(<q-args>, <bang>0)
command! -bang -nargs=? -complete=dir ClapMyAllFiles call clap_settings#files#myallfiles(<q-args>, <bang>0)

let g:loaded_clap_settings_vim = 1

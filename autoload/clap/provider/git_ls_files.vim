let s:save_cpo = &cpoptions
set cpoptions&vim

let s:git_ls_files_command = 'git ls-files . --cached --others --exclude-standard'

function! s:init() abort
    let cwd = clap#rooter#working_dir()
    call clap#client#notify_on_init({ 'cwd': cwd })
endfunction

function s:source() abort
    let cwd = clap#rooter#working_dir()
    return printf('cd %s && %s', shellescape(cwd), s:git_ls_files_command)
endfunction

let s:git_ls_files = {}
let s:git_ls_files.init = function('s:init')
let s:git_ls_files.source = function('s:source')
let s:git_ls_files.sink = function('clap#provider#files#sink_impl')
let s:git_ls_files['sink*'] = function('clap#provider#files#sink_star_impl')
let s:git_ls_files.on_move = function('clap#provider#files#on_move_impl')
let s:git_ls_files.icon = 'File'
let s:git_ls_files.syntax = 'clap_files'
let s:git_ls_files.enable_rooter = v:true
let s:git_ls_files.support_open_action = v:true

let g:clap#provider#git_ls_files# = s:git_ls_files

let &cpoptions = s:save_cpo
unlet s:save_cpo

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:init() abort
    let cwd = clap#rooter#working_dir()
    call clap#client#notify_on_init({ 'cwd': cwd })
endfunction

function s:source() abort
    let cwd = clap#rooter#working_dir()
    return printf(g:clap_find_all_command, shellescape(cwd))
endfunction

let s:myallfiles = {}
let s:myallfiles.init = function('s:init')
let s:myallfiles.source = function('s:source')
let s:myallfiles.sink = function('clap#provider#files#sink_impl')
let s:myallfiles['sink*'] = function('clap#provider#files#sink_star_impl')
let s:myallfiles.on_move = function('clap#provider#files#on_move_impl')
let s:myallfiles.icon = 'File'
let s:myallfiles.syntax = 'clap_files'
let s:myallfiles.enable_rooter = v:true
let s:myallfiles.support_open_action = v:true

let g:clap#provider#myallfiles# = s:myallfiles

let &cpoptions = s:save_cpo
unlet s:save_cpo

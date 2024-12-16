" Author: Phong Nguyen
" Description: List the files by fd or rg.
let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:init() abort
    let cwd = clap#rooter#working_dir()
    call clap#client#notify_on_init({ 'cwd': cwd })
endfunction

function s:source() abort
    let cwd = clap#rooter#working_dir()
    return printf(g:clap_find_command, shellescape(cwd))
endfunction

let s:myfiles = {}
let s:myfiles.init = function('s:init')
let s:myfiles.source = function('s:source')
let s:myfiles.sink = function('clap#provider#files#sink_impl')
let s:myfiles['sink*'] = function('clap#provider#files#sink_star_impl')
let s:myfiles.on_move = function('clap#provider#files#on_move_impl')
let s:myfiles.icon = 'File'
let s:myfiles.syntax = 'clap_files'
let s:myfiles.enable_rooter = v:true
let s:myfiles.support_open_action = v:true

let g:clap#provider#myfiles# = s:myfiles

let &cpoptions = s:save_cpo
unlet s:save_cpo

" Copied from https://github.com/liuchengxu/vim-clap/blob/master/autoload/clap/provider/buffers.vim
" and changed its buffer listing to the following format:
"
" [2]      clap.vim:20       [+-]   %   vim/plugins/
" [5]      default.vim:30              vim/bundles/
" [6]      .gitignore:10            #   ./
"

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:cur_tab_only = get(g:, 'clap_provider_buflist_cur_tab_only', v:false)
let s:path_shorten = get(g:, 'clap_provider_buflist_path_shorten', v:true)
let s:path_max_length = get(g:, 'clap_provider_buflist_path_max_length', 45)
let s:path_separator = has('win32') ? '\' : '/'

function! s:padding(origin, target_width) abort
  let width = strdisplaywidth(a:origin)
  if width < a:target_width
    return a:origin.repeat(' ', a:target_width - width)
  else
    return a:origin
  endif
endfunction

function! s:modified_status(b) abort
  if getbufvar(a:b, '&modified')
    return !getbufvar(a:b, '&modifiable') ? ' [+-]' : ' [+]'
  else
    return !getbufvar(a:b, '&modifiable') ? ' [-]' : ''
  endif
endfunction

function! s:shorten_dir(dir) abort
  let l:dir = a:dir
  if s:path_shorten && strlen(l:dir) >= s:path_max_length
    let l:dir = pathshorten(fnamemodify(l:dir, ':h')) . s:path_separator . fnamemodify(l:dir, ':t')
  endif
  return l:dir
endfunction

function! s:format_buffer(b, maxlen) abort
  let buffer_name = bufname(a:b)
  let fullpath = empty(buffer_name) ? '[No Name]' : fnamemodify(buffer_name, ':p:~:.')
  let filename = empty(fullpath) ? '[No Name]' : fnamemodify(fullpath, ':t')
  let flag = a:b == bufnr('')  ? '%' : (a:b == bufnr('#') ? '#' : ' ')
  let modified = s:modified_status(a:b)
  let readonly = getbufvar(a:b, '&readonly') ? ' ' : ''

  let bp = s:padding('['.a:b.']', 5)
  let icon = g:clap_enable_icon ? s:padding(clap#icon#for(fullpath), 3) : ''
  let extra = join(filter([modified, readonly], '!empty(v:val)'), '')
  let line = get(s:line_info, a:b, '')
  let line = substitute(line, 'line ', ':', '')
  " let line = (line ==# 'line 1' ? '' : substitute(line, 'line ', ':', ''))

  let dir = s:shorten_dir(fnamemodify(fullpath, ':h')) . s:path_separator
  let name = s:padding(filename . line, a:maxlen + 5)
  let extra = s:padding(extra, 6)
  let flag = s:padding(flag, 3)

  return trim(printf('%s %s %s %s %s %s', bp, icon, name, extra, flag, dir))
endfunction

function! s:buffers() abort
  let l:buffers = execute('buffers')
  let s:line_info = {}
  for line in split(l:buffers, "\n")
    let bufnr = str2nr(trim(matchstr(line, '^\s*\d\+')))
    let lnum = matchstr(line, '\s\+\zsline.*$')
    let s:line_info[bufnr] = lnum
  endfor
  let maxlen = max(map(clap#util#buflisted_sorted(s:cur_tab_only), 'strlen(fnamemodify(bufname(v:val), ":t"))'))
  let bufs = map(clap#util#buflisted_sorted(s:cur_tab_only), 's:format_buffer(str2nr(v:val), maxlen)')
  if empty(bufs)
    return []
  else
    return bufs[1:] + [bufs[0]]
  endif
endfunction

function! s:extract_bufnr(line) abort
  return matchstr(a:line, '^\[\zs\d\+\ze\]')
endfunction

function! s:buffers_sink(selected) abort
  let b = s:extract_bufnr(a:selected)
  if has_key(g:clap, 'open_action')
    execute g:clap.open_action
  endif
  execute 'buffer' b
endfunction

function! s:buffers_on_move() abort
  let curline = g:clap.display.getcurline()
  if empty(curline)
    return
  endif
  let bufnr = str2nr(s:extract_bufnr(curline))
  if !has_key(s:line_info, bufnr)
    return
  endif
  let lnum = str2nr(matchstr(s:line_info[bufnr], '\d\+'))
  let [start, end, hi_lnum] = clap#preview#get_range(lnum)
  let lines = getbufline(bufnr, start+1, end+1)
  call insert(lines, bufname(bufnr))
  call g:clap.preview.show(lines)
  call g:clap.preview.setbufvar('&syntax', getbufvar(bufnr, '&syntax'))
  call clap#preview#highlight_header()
endfunction

function! clap#provider#buflist#preview_target() abort
  let curline = g:clap.display.getcurline()
  if empty(curline)
    return []
  endif
  let bufnr = str2nr(s:extract_bufnr(curline))
  if !has_key(s:line_info, bufnr)
    return []
  endif
  let lnum = matchstr(s:line_info[bufnr], '\d\+')
  return [expand('#'.bufnr.':p'), lnum]
endfunction

function! s:action_delete() abort
  let current_matches = g:clap.display.line_count()
  execute 'bdelete' s:current_bufnr
  call g:clap.display.deletecurline()
  call clap#indicator#update_on_deletecurline()
  call g:clap.preview.hide()
  call g:clap#display_win.shrink_if_undersize()
endfunction

function! s:actions_title() abort
  let s:current_bufnr = s:extract_bufnr(g:clap.display.getcurline())
  return 'Choose action for buffer '.s:current_bufnr.':'
endfunction

let s:buflist = {}
let s:buflist.sink = function('s:buffers_sink')
let s:buflist.source = function('s:buffers')
let s:buflist.on_move = function('s:buffers_on_move')
let s:buflist.on_move_async = { -> clap#client#notify_provider('on_move') }
let s:buflist.syntax = 'clap_buflist'
let s:buflist.support_open_action = v:true
let s:buflist.action = {
      \ 'title': function('s:actions_title'),
      \ '&Delete': function('s:action_delete'),
      \ 'OpenInNew&Tab': { -> clap#selection#try_open('ctrl-t') },
      \ 'Open&Vertically': { -> clap#selection#try_open('ctrl-v') },
      \ 'Open&Split': { -> clap#selection#try_open('ctrl-x') },
      \ }

let g:clap#provider#buflist# = s:buflist

let &cpoptions = s:save_cpo
unlet s:save_cpo

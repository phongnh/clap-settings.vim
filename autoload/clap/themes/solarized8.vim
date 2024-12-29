let s:save_cpo = &cpoptions
set cpoptions&vim

" Copy this definition style from https://github.com/liuchengxu/vim-clap
" Use definition to easily modify palette
let s:base03  = { 'hex': '#002b36', 'xterm': '234', 'xterm_hex': '#1c1c1c' }
let s:base02  = { 'hex': '#073642', 'xterm': '235', 'xterm_hex': '#262626' }
let s:base01  = { 'hex': '#586e75', 'xterm': '240', 'xterm_hex': '#585858' }
let s:base00  = { 'hex': '#657b83', 'xterm': '241', 'xterm_hex': '#626262' }
let s:base0   = { 'hex': '#839496', 'xterm': '244', 'xterm_hex': '#808080' }
let s:base1   = { 'hex': '#93a1a1', 'xterm': '245', 'xterm_hex': '#8a8a8a' }
let s:base2   = { 'hex': '#eee8d5', 'xterm': '254', 'xterm_hex': '#e4e4e4' }
let s:base3   = { 'hex': '#fdf6e3', 'xterm': '230', 'xterm_hex': '#ffffd7' }
let s:yellow  = { 'hex': '#b58900', 'xterm': '136', 'xterm_hex': '#af8700' }
let s:orange  = { 'hex': '#cb4b16', 'xterm': '166', 'xterm_hex': '#d75f00' }
let s:red     = { 'hex': '#dc322f', 'xterm': '160', 'xterm_hex': '#d70000' }
let s:magenta = { 'hex': '#d33682', 'xterm': '125', 'xterm_hex': '#af005f' }
let s:violet  = { 'hex': '#6c71c4', 'xterm':  '61', 'xterm_hex': '#5f5faf' }
let s:blue    = { 'hex': '#268bd2', 'xterm':  '33', 'xterm_hex': '#0087ff' }
let s:cyan    = { 'hex': '#2aa198', 'xterm':  '37', 'xterm_hex': '#00afaf' }
let s:green   = { 'hex': '#859900', 'xterm':  '64', 'xterm_hex': '#5f8700' }

function! clap#themes#solarized8#init() abort
    if &background == 'dark'
        let s:palette = {
                    \ 'display': {
                    \   'guifg':   s:base0.hex,
                    \   'ctermfg': s:base0.xterm,
                    \   'guibg':   s:base02.hex,
                    \   'ctermbg': s:base02.xterm,
                    \ },
                    \ 'input': {
                    \   'guibg':   s:base02.hex,
                    \   'ctermbg': s:base02.xterm
                    \ },
                    \ 'indicator': {
                    \   'guifg':   s:yellow.hex,
                    \   'ctermfg': s:yellow.xterm,
                    \   'guibg':   s:base02.hex,
                    \   'ctermbg': s:base02.xterm,
                    \  },
                    \ 'spinner': {
                    \   'guifg':   s:yellow.hex,
                    \   'ctermfg': s:yellow.xterm,
                    \   'guibg':   s:base02.hex,
                    \   'ctermbg': s:base02.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'search_text': {
                    \   'guifg':   s:base0.hex,
                    \   'ctermfg': s:base0.xterm,
                    \   'guibg':   s:base02.hex,
                    \   'ctermbg': s:base02.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'preview': {
                    \   'guifg':   s:base0.hex,
                    \   'ctermfg': s:base0.xterm,
                    \   'guibg':   s:base03.hex,
                    \   'ctermbg': s:base03.xterm,
                    \ },
                    \ 'current_selection': {
                    \   'guibg':   s:base03.hex,
                    \   'ctermbg': s:base03.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'current_selection_sign': {
                    \   'guifg':   s:orange.hex,
                    \   'ctermfg': s:orange.xterm,
                    \   'guibg':   s:base03.hex,
                    \   'ctermbg': s:base03.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'selected': {
                    \   'guifg':   s:blue.hex,
                    \   'ctermfg': s:blue.xterm,
                    \   'guibg':   s:base03.hex,
                    \   'ctermbg': s:base03.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'selected_sign': {
                    \   'guifg':   s:red.hex,
                    \   'ctermfg': s:red.xterm,
                    \   'guibg':   s:base03.hex,
                    \   'ctermbg': s:base03.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold'
                    \ },
                    \ }

        let s:fuzzy = [
                    \   [s:base01.xterm, s:base1.hex],
                    \ ]
    else
        let s:palette = {
                    \ 'display': {
                    \   'guifg':   s:base00.hex,
                    \   'ctermfg': s:base00.xterm,
                    \   'guibg':   s:base2.hex,
                    \   'ctermbg': s:base2.xterm,
                    \ },
                    \ 'input': {
                    \   'guibg':   s:base2.hex,
                    \   'ctermbg': s:base2.xterm,
                    \ },
                    \ 'indicator': {
                    \   'guifg':   s:yellow.hex,
                    \   'ctermfg': s:yellow.xterm,
                    \   'guibg':   s:base2.hex,
                    \   'ctermbg': s:base2.xterm,
                    \ },
                    \ 'spinner': {
                    \   'guifg':   s:yellow.hex,
                    \   'ctermfg': s:yellow.xterm,
                    \   'guibg':   s:base2.hex,
                    \   'ctermbg': s:base2.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'search_text': {
                    \   'guifg':   s:base00.hex,
                    \   'ctermfg': s:base00.xterm,
                    \   'guibg':   s:base2.hex,
                    \   'ctermbg': s:base2.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'preview': {
                    \   'guifg':   s:base00.hex,
                    \   'ctermfg': s:base00.xterm,
                    \   'guibg':   s:base3.hex,
                    \   'ctermbg': s:base3.xterm ,
                    \ },
                    \ 'current_selection': {
                    \   'guibg':   s:base3.hex,
                    \   'ctermbg': s:base3.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'current_selection_sign': {
                    \   'guifg':   s:orange.hex,
                    \   'ctermfg': s:orange.xterm,
                    \   'guibg':   s:base3.hex,
                    \   'ctermbg': s:base3.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'selected': {
                    \   'guifg':   s:blue.hex,
                    \   'ctermfg': s:blue.xterm,
                    \   'guibg':   s:base3.hex,
                    \   'ctermbg': s:base3.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ 'selected_sign': {
                    \   'guifg':   s:red.hex,
                    \   'ctermfg': s:red.xterm,
                    \   'guibg':   s:base3.hex,
                    \   'ctermbg': s:base3.xterm,
                    \   'gui':     'bold',
                    \   'cterm':   'bold',
                    \ },
                    \ }

        let s:fuzzy = [
                    \   [s:base01.xterm, s:base01.hex],
                    \ ]
    endif

    if exists('g:clap')
        call clap#highlighter#clear_display()
    endif

    let l:index = 0
    for [l:ctermfg, l:guifg] in s:fuzzy
        let l:index += 1
        let l:group = 'ClapFuzzyMatches' . l:index
        execute 'highlight clear ' . l:group
        execute printf(
                    \ 'highlight %s ctermfg=%s guifg=%s ctermbg=%s guibg=%s gui=bold cterm=bold',
                    \ l:group,
                    \ l:ctermfg,
                    \ l:guifg,
                    \ 'NONE',
                    \ 'NONE'
                    \ )
    endfor

    let g:clap_fuzzy_match_hl_groups        = s:fuzzy
    let g:__clap_fuzzy_matches_hl_group_cnt = len(g:clap_fuzzy_match_hl_groups)
    let g:__clap_fuzzy_last_hl_group        = 'ClapFuzzyMatches' . g:__clap_fuzzy_matches_hl_group_cnt

    execute 'highlight clear ClapFile'
    execute printf(
        \ 'highlight ClapFile ctermfg=%s ctermbg=NONE guifg=%s guibg=NONE',
        \ s:palette.display.ctermfg,
        \ s:palette.display.guifg
        \ )
    execute printf(
                \ 'highlight ClapVistaBracket ctermbg=%s guibg=%s',
                \ s:palette.display.ctermbg,
                \ s:palette.display.guibg
                \ )

    let g:clap#themes#solarized8#palette = s:palette
endfunction

call clap#themes#solarized8#init()

let &cpoptions = s:save_cpo
unlet s:save_cpo

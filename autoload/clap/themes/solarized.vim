let s:save_cpo = &cpoptions
set cpoptions&vim

function s:SetClapTheme() abort
    if &background == 'dark'
        let s:palette = {
                    \ 'display':                { 'guifg': '#839496', 'guibg': '#002b36', 'ctermfg': '102', 'ctermbg': '17' },
                    \ 'input':                  { 'guibg': '#002b36', 'ctermbg': '17' },
                    \ 'spinner':                { 'guifg': '#b58900', 'guibg': '#002b36', 'ctermfg': '136', 'ctermbg': '17', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'search_text':            { 'guifg': '#839496', 'guibg': '#002b36', 'ctermfg': '102', 'ctermbg': '17', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'preview':                { 'guifg': '#839496', 'guibg': '#002b36', 'ctermfg': '102', 'ctermbg': '17' },
                    \ 'current_selection':      { 'guifg': '#93a1a1', 'guibg': '#073642', 'ctermfg': '109', 'ctermbg': '23', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'current_selection_sign': { 'guifg': '#cb4b16', 'guibg': '#073642', 'ctermfg': '166', 'ctermbg': '23', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'selected':               { 'guifg': '#268bd2', 'guibg': '#073642', 'ctermfg': '32',  'ctermbg': '23', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'selected_sign':          { 'guifg': '#dc322f', 'guibg': '#073642', 'ctermfg': '166', 'ctermbg': '23', 'cterm': 'bold', 'gui': 'bold' },
                    \ }
    else
        let s:palette = {
                    \ 'display':                { 'guifg': '#657b83', 'guibg': '#fdf6e3', 'ctermfg': '66',  'ctermbg': '230' },
                    \ 'input':                  { 'guibg': '#fdf6e3', 'ctermbg': '230'  },
                    \ 'spinner':                { 'guifg': '#b58900', 'guibg': '#fdf6e3', 'ctermfg': '136', 'ctermbg': '230', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'search_text':            { 'guifg': '#657b83', 'guibg': '#fdf6e3', 'ctermfg': '66',  'ctermbg': '230', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'preview':                { 'guifg': '#657b83', 'guibg': '#fdf6e3', 'ctermfg': '66',  'ctermbg': '230' },
                    \ 'current_selection':      { 'guifg': '#586e75', 'guibg': '#eee8d5', 'ctermfg': '60',  'ctermbg': '224', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'current_selection_sign': { 'guifg': '#cb4b16', 'guibg': '#eee8d5', 'ctermfg': '166', 'ctermbg': '224', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'selected':               { 'guifg': '#268bd2', 'guibg': '#eee8d5', 'ctermfg': '32',  'ctermbg': '224', 'cterm': 'bold', 'gui': 'bold' },
                    \ 'selected_sign':          { 'guifg': '#dc322f', 'guibg': '#eee8d5', 'ctermfg': '166', 'ctermbg': '224', 'cterm': 'bold', 'gui': 'bold' },
                    \ }
    endif

    let g:clap#themes#solarized#palette = s:palette
endfunction

call s:SetClapTheme()

augroup VimClapThemesSolarized
    autocmd!
    autocmd ColorschemePre * call <SID>SetClapTheme()
augroup END

let &cpoptions = s:save_cpo
unlet s:save_cpo


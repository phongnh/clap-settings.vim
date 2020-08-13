function! clap#themes#solarized#init() abort
    if &background == 'dark'
        let s:palette = {
                    \ 'display':                { 'guifg': '#839496', 'ctermfg': '244', 'guibg': '#002b36', 'ctermbg': '234' },
                    \ 'input':                  { 'guibg': '#002b36', 'ctermbg': '234' },
                    \ 'spinner':                { 'guifg': '#b58900', 'ctermfg': '136', 'guibg': '#002b36', 'ctermbg': '234', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'search_text':            { 'guifg': '#839496', 'ctermfg': '244', 'guibg': '#002b36', 'ctermbg': '234', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'preview':                { 'guifg': '#839496', 'ctermfg': '244', 'guibg': '#002b36', 'ctermbg': '234' },
                    \ 'current_selection':      { 'guibg': '#073642', 'ctermbg': '235',  'gui':   'bold',    'cterm':   'bold' },
                    \ 'current_selection_sign': { 'guifg': '#cb4b16', 'ctermfg': '166', 'guibg': '#073642', 'ctermbg': '235', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'selected':               { 'guifg': '#268bd2', 'ctermfg': '33',  'guibg': '#073642', 'ctermbg': '235', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'selected_sign':          { 'guifg': '#dc322f', 'ctermfg': '160', 'guibg': '#073642', 'ctermbg': '235', 'gui': 'bold', 'cterm': 'bold' },
                    \ }
        if has('nvim')
            let s:palette.preview = { 'guifg': '#93a1a1', 'ctermfg': '109', 'guibg': '#073642', 'ctermbg': '235' }
        endif
    else
        let s:palette = {
                    \ 'display':                { 'guifg': '#657b83', 'ctermbg': '230', 'guibg': '#fdf6e3', 'ctermfg': '230' },
                    \ 'input':                  { 'guibg': '#fdf6e3', 'ctermbg': '230'  },
                    \ 'spinner':                { 'guifg': '#b58900', 'ctermfg': '136', 'guibg': '#fdf6e3', 'ctermbg': '230', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'search_text':            { 'guifg': '#657b83', 'ctermfg': '241', 'guibg': '#fdf6e3', 'ctermbg': '230', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'preview':                { 'guifg': '#657b83', 'ctermfg': '241', 'guibg': '#fdf6e3', 'ctermbg': '230' },
                    \ 'current_selection':      { 'guibg': '#eee8d5', 'ctermbg': '224', 'gui':   'bold',    'cterm':   'bold' },
                    \ 'current_selection_sign': { 'guifg': '#cb4b16', 'ctermfg': '166', 'guibg': '#eee8d5', 'ctermbg': '224', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'selected':               { 'guifg': '#268bd2', 'ctermfg': '33',  'guibg': '#eee8d5', 'ctermbg': '224', 'gui': 'bold', 'cterm': 'bold' },
                    \ 'selected_sign':          { 'guifg': '#dc322f', 'ctermfg': '160', 'guibg': '#eee8d5', 'ctermbg': '224', 'gui': 'bold', 'cterm': 'bold' },
                    \ }
        if has('nvim')
            let s:palette.preview = { 'guifg': '#586e75', 'ctermfg': '60',  'guibg': '#eee8d5', 'ctermbg': '224' }
        endif
    endif

    let g:clap#themes#solarized#palette = s:palette
endfunction

if exists('g:loaded_clap_solarized_theme')
    finish
endif
let g:loaded_clap_solarized_theme = 1


if get(g:, 'clap_solarized_theme', 0)
    let g:clap_theme = 'solarized'

    function! s:InitSolarizedColorscheme() abort
        call clap#themes#solarized#init()
    endfunction

    call s:InitSolarizedColorscheme()

    augroup VimClapSolarizedTheme
        autocmd!
        autocmd ColorschemePre * call <SID>InitSolarizedColorscheme()
        autocmd Colorscheme * call clap#themes#init()
    augroup END
endif

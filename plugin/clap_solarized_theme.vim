if exists('g:loaded_clap_solarized_theme')
    finish
endif
let g:loaded_clap_solarized_theme = 1

if get(g:, 'clap_solarized_theme', 0)
    let g:clap_theme = 'solarized'

    call clap#themes#solarized#init()

    function! s:ReloadSolarizedTheme() abort
        call clap#themes#solarized#init()
        call clap#themes#init()
    endfunction

    augroup VimClapSolarizedTheme
        autocmd!
        autocmd ColorschemePre * call <SID>ReloadSolarizedTheme()
    augroup END
endif

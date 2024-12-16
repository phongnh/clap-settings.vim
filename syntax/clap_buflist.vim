syntax match ClapBuflistNumberBracket  /\[\|\]/ contained
syntax match ClapBuflistNumber /^\[\d\+\]/ contains=ClapBuflistNumberBracket
syntax match ClapBuflistLnum /:\d\+/ contained
syntax match ClapBuflistFname /\s\+\(\h\|-\|\d\|\.\)\+:\d\+/ contains=ClapBuflistLnum
syntax match ClapBuflistFlags /\s\+\(\[\(+\|-\|+-\)\]\|\)/
syntax match ClapBuflistExtra /\s\+[#%]/
syntax match ClapBuflistPath /\s\+\(\(\h\|-\|\d\|\.\|\~\)\+\/\)\+$/

hi default link ClapBuflistNumberBracket Number
hi default link ClapBuflistNumber        Function
hi default link ClapBuflistLnum          Normal
hi default link ClapBuflistFname         Normal
hi default link ClapBuflistFlags         Type
hi default link ClapBuflistExtra         SpecialChar
hi default link ClapBuflistPath          String

syntax match ClapBuflistNumberBracket  /\[\|\]/ contained
syntax match ClapBuflistNumber /^\[\d\+\]/ contains=ClapBuflistNumberBracket
syntax match ClapBuflistLnum /:\d\+/ contained
syntax match ClapBuflistFname /\s\+\(\h\|\d\|\.\)\+:\d\+\s\+/ contains=ClapBuflistLnum
syntax match ClapBuflistFlags /\[\(+\|-\|+-\|RO\)\]/
syntax match ClapBuflistExtra /#\|%/

hi default link ClapBuflistNumberBracket Number
hi default link ClapBuflistNumber        Function
hi default link ClapBuflistLnum          Normal
hi default link ClapBuflistFlags         Normal
hi default link ClapBuflistExtra         SpecialChar
hi default link ClapBuflistFname         String

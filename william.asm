.label border = $d020
.label screen = $d021


*=$C000
main:
jsr set_screen

end:
rts

//---subroutines---
set_screen:
lda #$02
sta border
lda #$00
sta screen

rts
//================Subroutines===================
waitKey:
jsr GETIN
beq waitKey
rts

dash_update_dtime:
clc
lda #<s_start
adc #$0d
sta S_REC_LOC
lda #$0e
sta x_txt
jmp top_hdr

dash_update_atime:
clc
lda #<s_start
adc #$13
sta S_REC_LOC
lda #$14
sta x_txt
jmp top_hdr

dash_update_flt:
clc
lda #<s_start
adc #$08
sta S_REC_LOC
lda #$01
sta x_txt
jmp top_hdr

dash_update_arr:
clc
lda #<s_start
adc #$04
sta S_REC_LOC
lda #$0a
sta x_txt
jmp top_hdr


dash_update_dep:
lda #<s_start
sta S_REC_LOC
lda #$06
sta x_txt

top_hdr:
lda #>s_start
sta S_REC_LOC+1
lda #$09
sta y_txt
lda S_REC_LOC
sta $02
lda S_REC_LOC + 1
sta $03
ldx #$04

top:
txa
pha

//PlotXY
ldx y_txt
ldy x_txt
clc 
jsr PLOT
pla
tax


ldy #$00
loop:
lda ($02),y
beq done
jsr CHROUT 
iny        
jmp loop 

done:        
clc
lda #$20
adc $02
sta $02

inc y_txt
//inc x_txt

dex
bne top

rts


dashboard:
jsr dash_update_dep
jsr dash_update_arr
jsr dash_update_flt
jsr dash_update_dtime
jsr dash_update_atime
rts

//-----check and increment day if needed
new_day_check:
{
lda FLAG_DAY
//cmp #$00
bne end
lda CIA1_HOUR
cmp #$12
bne end
//.break
inc DAY
inc FLAG_DAY
//.break
//SetCIATOD($12,$59,$40)
end:
rts
}

//-----Reset and arm flag for end of day new_day_check
reset_day_check_flag:
lda FLAG_DAY
cmp #$00
beq end
lda CIA1_HOUR
cmp #$01
bne end
//inc DAY
.break
lda #$00
sta FLAG_DAY
end:
rts

//-----calendar day maintnenace
calendar_maintenance:
{
lda DAY
cmp #$32
bne end
lda #$01
sta DAY
//lda MONTH
clc
sed
lda #$01
adc MONTH
sta MONTH
cld

//-----check for month = $13
lda MONTH
cmp #$13
bne end
lda #$01
sta MONTH
end:
rts
}


//---------mult40
mult40:
        lda num       //;Start with RESULT = NUM
        sta result
        lda num+1
        sta result
        sta result+1
        asl result
        rol result+1  //;RESULT = 2*NUM
        asl result
        rol result+1  //;RESULT = 4*NUM
        clc
        lda num
        adc result
        sta result
        lda num+1
        adc result+1
        sta result+1  //;RESULT = 5*NUM
        asl result
        rol result+1  //;RESULT = 10*NUM
        asl result
        rol result+1  //;RESULT = 20*NUM
        asl result
        rol result+1  //;RESULT = 40*NUM
        rts




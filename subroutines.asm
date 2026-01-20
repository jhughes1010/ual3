//================Subroutines===================
//-----------------------------------------------
//-----------------------------------------------
//-----------------------------------------------
waitKey:
    jsr GETIN
    beq waitKey
    rts


//-----------------------------------------------
//-----dashboard entry points
//-----------------------------------------------
dash_update_dtime:
    clc
    lda #<s_start
    adc #$0f
    sta REC_MEM
    lda #$10
    sta x_txt
    jmp top_hdr

dash_update_atime:
    clc
    lda #<s_start
    adc #$15
    sta REC_MEM
    lda #$16
    sta x_txt
    jmp top_hdr

dash_update_flt:
    clc
    lda #<s_start
    adc #$00
    sta REC_MEM
    lda #$01
    sta x_txt
    jmp top_hdr

dash_update_arr:
    clc
    lda #<s_start
    adc #$0b
    sta REC_MEM
    lda #$0c
    sta x_txt
    jmp top_hdr


dash_update_dep:
    lda #<s_start
    adc #$07
    sta REC_MEM
    lda #$08
    sta x_txt

top_hdr:
    lda #>s_start
    sta REC_MEM+1
    lda #$09
    sta y_txt
    lda REC_MEM
    sta $02
    lda REC_MEM + 1
    sta $03
    ldx #$08

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

//-----------------------------------------------
//-----check and increment day if needed
//-----------------------------------------------
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

//-----------------------------------------------
//-----Reset and arm flag for end of day new_day_check
//-----------------------------------------------
reset_day_check_flag:
    lda FLAG_DAY
    cmp #$00
    beq end
    lda CIA1_HOUR
    cmp #$01
    bne end
    //inc DAY
    //.break
    lda #$00
    sta FLAG_DAY
    end:
    rts

//-----------------------------------------------
//-----calendar day maintnenace
//-----------------------------------------------
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

//-----------------------------------------------
//---mult40
//-----------------------------------------------
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
    .break
    rts

//-----------------------------------------------
//---set TOD via reserved memory locations (preloaded)
//-----------------------------------------------
setCIATOD:
{
    //is hour >11am
    //.break
    lda HOUR
    cmp #$11
    bmi settime 
    sed
    //lda HOUR
    sbc #$12
    ora #$80
    cld
    sta HOUR
    //brk
settime:
    lda HOUR
    sta CIA1_HOUR
    lda MINUTE
    sta CIA1_MIN
    lda SECOND
    sta CIA1_SEC
    lda #$00
    sta CIA1_TENTH
    rts
}

//-----------------------------------------------
//---dashboard display for current day flights
//-----------------------------------------------
dashboard_update:
{
    //to be replaced with date filter function
    ldx #45    //record count
    lda #$09
    sta y_txt
    
    //calc record start address in memory
    //and place in REC_MEM
    //REC_MEM=s_start+REC_PTR*$20
    lda #<s_start
    sta zp_0
    lda #>s_start
    sta zp_0+1
loop:
    //check for end of table data
    ldy#$00
    lda (zp_0),y
    beq end
    //plot record to screen
    jsr write_record
    //inc y_txt


    //increment zp pointer and check for record end
    clc
    lda #s_size
    adc zp_0
    sta zp_0
    lda #$00
    adc zp_0+1
    sta zp_0+1
    dex
    bne loop
<<<<<<< HEAD
end:
=======
>>>>>>> 317d9ffc849199d8659ad15d253c4791042dceea
    //.break

    rts
}

<<<<<<< HEAD
write_record:
    tya
    pha
    txa
    pha

    ldy #27
    lda (zp_0),y 
    cmp DAY
    bne skip_output

    //flight
    ldx y_txt
    PlotX(1)
    //OutputText(REC_TEST)
    OutputZP_0Text(0)

    //dep
    ldx y_txt
    PlotX(8)
    OutputZP_0Text(7)

    //arr
    ldx y_txt
    PlotX(12)
    OutputZP_0Text(11)

     //time depart
    ldx y_txt
    PlotX(16)
    OutputZP_0Text(15)

    //time arrive
    ldx y_txt
    PlotX(22)
    OutputZP_0Text(21)

    //date - do not display
    //ldx y_txt
    //PlotX(28)
    //OutputZP_0Text(27)

    inc y_txt


skip_output:
   pla
    tax
    pla
    tay 
    rts
=======
   setSchColor:
   {
    ldx #$00
 loop:
   // .break
    lda #$05
    sta SCREEN_COLOR_RAM_SCH,x
    inx
    bne loop


    end:
    rts
   }
>>>>>>> 317d9ffc849199d8659ad15d253c4791042dceea

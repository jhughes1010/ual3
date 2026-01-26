//================Subroutines===================
//-----------------------------------------------
//-----------------------------------------------
//-----------------------------------------------
waitKey:
    jsr GETIN
    beq waitKey
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
    //clear screen memory schedule row 9 to14
    jsr clear_board

    ldx #10     //record count
    lda #$09    //column 9
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
end:
    rts
}
//-----------------------------------------------
//---if day matches, write current record to the screen
//-----------------------------------------------
write_record:
{
    PushXYStack()
    ldy #27
    lda (zp_0),y 
    cmp DAY
    bne end

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

    inc y_txt
end:
    PullXYStack()
}  
setSchColor:
{
    ldx #$00
 loop:
    lda #$05
    sta SCREEN_COLOR_RAM_SCH,x
    inx
    bne loop
end:
    rts
   }
//-----------------------------------------------
//---clear 5 rows of flight board
//-----------------------------------------------

clear_board:
{
    lda #<SCREEN_FLIGHTS
    sta zp_0
    lda #>SCREEN_FLIGHTS
    sta zp_0+1
    //5 rows
    ldx#05
new_row:
    //38 columns to clear
    ldy #37
clear_row:
    lda #SPACE
    sta (zp_0),y
    dey
    bpl clear_row
    //add 40d to zp_0
    clc
    lda #SCREEN_COLUMN_WIDTH
    adc zp_0
    sta zp_0
    lda #$00
    adc zp_0 + 1
    sta zp_0 + 1
    dex
    bne new_row
    rts 
}

//---set time and date via TELNET time server
set_time_date:
    SetBorderColor(3)
    SetScreenColor(6)
    ClearScreen()
    jsr init_comm  // Initialize comm channel
    OutputText(COMM_TITLE)
    delaySec(1)
    jsr clear_buffer
    sendCommMessage(MSG_CONNECT)
    jsr CLRCHN
    OutputText(COMM_TELNET)
    delaySec(4)
    jsr clear_buffer
    sendCommMessage(MSG_DTTM)
    jsr CLRCHN
    OutputText(COMM_DATE)
    delaySec(2)
    jsr clear_buffer
    jsr parse_date_time
    rts

//---init comm channel
init_comm:
    jsr CLALL
    //set baud rate and parity
    lda #$00
    sta cmd_reg
    lda #$06        //300 baud
    sta ctrl_reg
    //set name (points to cmd and ctrl registers)
    lda #$02
    ldx #$93
    ldy #$02
    jsr SETNAM
    //set file number via LFS
    lda #$80
    ldx #$02
    ldy #$ff
    jsr SETLFS
    jsr OPEN
    rts

//---clear RX buffer and send to screen
clear_buffer:
{
    jsr CLRCHN
    ClearScreen()

empty_buffer_loop:
    ldx #$80
    jsr CHKIN
    jsr GETIN
    sta $6a
    cmp #$00
    beq end
    jsr CLRCHN
    lda $6a
    jsr CHROUT
    jmp empty_buffer_loop
    end:
    rts
}

//---parse date and time from top row of screen memory
parse_date_time:
    //parse date
    getBCDvalue(screenDay,DAY)
    getBCDvalue(screenMonth,MONTH)
    getBCDvalue(screenYear,YEAR)

    //parse time
    getBCDvalue(screenHour,HOUR)
    getBCDvalue(screenMinute,MINUTE)
    getBCDvalue(screenSecond,SECOND)
    jsr setCIATOD
    rts
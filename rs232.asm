// Commodore 64 Dumb Terminal
// Baud Rate: 300



_settmdt:       //debug onlt, full terminal routine
SetBorderColor(3)
SetScreenColor(2)
ClearScreen()

jsr init_comm  // Initialize comm channel
jsr term_loop   // Enter main terminal loop
rts

settmdt:
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
//set name (points to cmd and ctrl)
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

//---terminal loop
term_loop:
jsr STOP
bne continue_comm
rts
continue_comm:

jsr CLRCHN
jsr GETIN
sta $6a
beq get_comm_in  
jsr extended
//.break
//lda $6a
//jsr CHROUT      //debug only
ldx #$80
jsr CHKOUT
lda $6a
jsr CHROUT
//send LF also
lda $6a
cmp #RETURN
bne get_comm_in
lda #$0a 
sta $6a
//ldx #$80
//jsr CHKOUT
lda $6a
jsr CHROUT



get_comm_in:
//jmp term_loop
ldx #$80
jsr CHKIN
jsr GETIN
sta $6a
//to screen???
//lda $6a
beq term_loop
jsr CLRCHN
lda $6a
jsr CHROUT
jmp term_loop


rts

clear_buffer:
{
//delaySec(3)
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



extended:
//check for f1 key
cmp #f1
bne chk_f3
delaySec($02)
ldx #$00
ClearScreen()

f1_text_loop:
lda MSG_CONNECT,x 
sta $6a
beq f1_end
//print message to screen and comm
//jsr CHROUT
txa
pha

ldx #$80
jsr CHKOUT
lda $6a
jsr CHROUT

pla
tax
inx
jmp f1_text_loop
f1_end:
rts

chk_f3:
//check for f3 key
cmp #f3
beq f3_cont
jmp chk_f4
f3_cont:
f3_read_info:
//read time and date from screen (static locations)
delaySec(4)
//date-day
//getBCDvalue(screenDay,DAY)
//getBCDvalue(screenMonth,MONTH)
//getBCDvalue(screenYear,YEAR)

f3_end:
rts

chk_f4:
cmp #f4
bne next
getBCDvalue(screenDay,DAY)
getBCDvalue(screenMonth,MONTH)
getBCDvalue(screenYear,YEAR)
//.break

rts
next:
rts

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

.macro sendCommMessage(message)
{
//ClearScreen()
ldx #$00
text_loop:
lda message,x 
sta $6a
beq end

txa
pha
ldx #$80
jsr CHKOUT
lda $6a
jsr CHROUT
pla
tax

inx
jmp text_loop
end:
nop
}




// Messages
MSG_INIT:
        .text "RS-232 TERMINAL INIT..."
        .byte RETURN,$00
MSG_READY:
        .text "READY AT 1200 BAUD"
        .byte RETURN
        .text "PRESS RUN/STOP-RESTORE TO EXIT"
        .byte RETURN, RETURN,$00

MSG_ERROR:
        .text "ERROR OPENING RS-232!"
        .byte RETURN,$00

MSG_CONNECT:
        .text "ATDT192.168.1.253"
        .byte RETURN, $0A, $00

MSG_DTTM:
        .text "DTTM"
        .byte RETURN, $0A, $00


MSG_TIME:
        .text "TIME"
        .byte RETURN, $0A, $00


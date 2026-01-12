// Commodore 64 RS-232 Dumb Terminal
// Baud Rate: 300
// Assembles at $C000


// Kernal routines
.label CHRIN   = $FFCF         // Input character
//.label CHROUT  = $FFD2         // Output character
//.label GETIN   = $FFE4         // Get character from keyboard
.label OPEN    = $FFC0         // Open file
.label CLOSE   = $FFC3         // Close file
.label CHKIN   = $FFC6         // Set input channel
.label CHKOUT  = $FFC9         // Set output channel
.label CLRCHN  = $FFCC         // Clear I/O channels
.label CLALL = $ffe7
//.label SETLFS  = $FFBA
//.label SETNAM  = $FFBD

.label ctrl_reg = $0293
.label cmd_reg = $0294

// Screen codes
.label CLRSCR  = $93           // Clear screen
.label RETURN  = $0D           // Return key

settmdt:
SetBorderColor(3)
SetScreenColor(2)
ClearScreen()

jsr init_comm  // Initialize comm channel
jsr term_loop   // Enter main terminal loop
rts

//---init rs232 channel
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
bne f3_end
ClearScreen()
ldx #$00
f3_text_loop:
lda MSG_DTTM,x 
sta $6a
beq f3_read_info
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
jmp f3_text_loop
f3_read_info:
//read time and date from screen (static locations)
delaySec(4)


f3_end:
rts




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


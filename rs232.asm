; Commodore 64 RS-232 Dumb Terminal
; Baud Rate: 300
; Assembles at $C000

        *= $C000

; Kernal routines
CHRIN   = $FFCF         ; Input character
CHROUT  = $FFD2         ; Output character
GETIN   = $FFE4         ; Get character from keyboard
OPEN    = $FFC0         ; Open file
CLOSE   = $FFC3         ; Close file
CHKIN   = $FFC6         ; Set input channel
CHKOUT  = $FFC9         ; Set output channel
CLRCHN  = $FFCC         ; Clear I/O channels

; Screen codes
CLRSCR  = $93           ; Clear screen
RETURN  = $0D           ; Return key

START:
        jsr INIT_RS232  ; Initialize RS-232
        jsr MAIN_LOOP   ; Enter main terminal loop
        rts

; Initialize RS-232 channel at 300 baud
INIT_RS232:
        lda #$93        ; Clear screen character
        jsr CHROUT
        
        ; Display initialization message
        ldx #$00
INIT_MSG:
        lda MSG_INIT,X
        beq OPEN_CH
        jsr CHROUT
        inx
        bne INIT_MSG

OPEN_CH:
        ; Open RS-232 channel
        ; OPEN 2,2,0,CHR$(6)
        ; LFN=2, Device=2 (RS-232), Secondary=0
        ; CHR$(6) = 300 baud, 8-N-1
        
        lda #$02        ; Logical file number
        ldx #$02        ; Device number (RS-232)
        ldy #$00        ; Secondary address (command channel)
        jsr OPEN
        bcs ERROR       ; Branch if error
        
        ; Send control string for 300 baud
        lda #$02        ; LFN
        jsr CHKOUT      ; Set output to RS-232
        
        lda #$06        ; Control byte: 300 baud, 8-N-1
                        ; Bit layout:
                        ; Bits 0-3: Baud rate (6 = 300 baud)
                        ; Bits 5-7: Word length, parity, stop bits
        jsr CHROUT
        
        jsr CLRCHN      ; Clear channels
        
        ; Display ready message
        ldx #$00
READY_MSG:
        lda MSG_READY,X
        beq INIT_DONE
        jsr CHROUT
        inx
        bne READY_MSG

INIT_DONE:
        rts

ERROR:
        ; Display error message
        ldx #$00
ERR_MSG:
        lda MSG_ERROR,X
        beq ERR_END
        jsr CHROUT
        inx
        bne ERR_MSG
ERR_END:
        pla             ; Pull return address
        pla
        rts             ; Exit program

; Main terminal loop
MAIN_LOOP:
        ; Check for keyboard input
        jsr GETIN
        cmp #$00
        beq CHECK_RS232 ; No key pressed
        
        ; Send to RS-232
        pha             ; Save character
        lda #$02
        jsr CHKOUT      ; Set output to RS-232
        pla
        jsr CHROUT      ; Send character
        jsr CLRCHN
        
        ; Echo to screen
        jsr CHROUT

CHECK_RS232:
        ; Check for RS-232 input
        lda #$02
        jsr CHKIN       ; Set input from RS-232
        jsr CHRIN       ; Get character
        pha             ; Save character
        jsr CLRCHN
        pla
        
        ; Check for actual data (not status)
        cmp #$00
        beq MAIN_LOOP   ; No data received
        
        ; Display received character
        jsr CHROUT
        
        jmp MAIN_LOOP

; Messages
MSG_INIT:
        .byte "RS-232 TERMINAL INIT...",RETURN,$00
MSG_READY:
        .byte "READY AT 300 BAUD",RETURN
        .byte "PRESS RUN/STOP-RESTORE TO EXIT",RETURN,RETURN,$00
MSG_ERROR:
        .byte "ERROR OPENING RS-232!",RETURN,$00

; Entry point message
        *= $CFFA
        .byte "SYS 49152 TO START",$00
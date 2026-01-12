// Set border color
.macro SetBorderColor(color) {
lda #color
sta $d020
}

// Set screen color
.macro SetScreenColor(color) {
lda #color
sta $d021
}

//Set text
.macro OutputText(text){
   ldx #$00   


loop:  
   lda text, x
        beq done
        jsr CHROUT 
        inx        
        jmp loop 

done:       
}

.macro PlotXY(x,y){
   ldy #x 
   ldx #y 
   clc 
   jsr PLOT
}

.macro ClearScreen(){
    lda #$93
    jsr CHROUT
}

.macro LoadFile(file_number,file_name,file_name_length,load_address)
{
   lda #file_name_length // File name size
   ldx #<file_name
   ldy #>file_name
   jsr SETNAM



   lda #file_number // File number
   ldx #9 // Device
   ldy #0 // Channel
   jsr SETLFS

   lda #00 // Load
   ldx #<load_address
   ldy #>load_address
   jsr LOAD
   bcs error
      jmp doneLoading
   error:
      sta SCREEN_RAM // Display error code in top left corner of screen
      lda #1
      sta SCREEN_COLOR_RAM
      rts
      
      // Value of A:
      //$05 Device not present
      //$04 File not found
      //$1D Load error
      //$00 Break run/stop pressed during loading
   doneLoading:
}

.macro SetCIATOD(hour, minute, second)
{
   //lda #%10000000
   //sta CIA1_CRB
   lda #hour
   sta CIA1_HOUR
   lda #minute
   sta CIA1_MIN
   lda #second
   sta CIA1_SEC
   lda #$00
   sta CIA1_TENTH
   //lda #$00
   //sta CIA1_CRB
}

.macro DisplayTOD()
{
   lda CIA1_HOUR
   and #$0f
   ora #$30
   sta SCREEN_RAM+6

   lda CIA1_HOUR
   and #$f0
   lsr  
   lsr 
   lsr 
   lsr
   ora #$30
   sta SCREEN_RAM+5

   lda CIA1_MIN
   and #$0f
   ora #$30
   sta SCREEN_RAM+9

   lda CIA1_MIN
   and #$f0
   lsr  
   lsr 
   lsr 
   lsr
   ora #$30
   sta SCREEN_RAM+8

   lda CIA1_SEC
   and #$0f
   ora #$30
   sta SCREEN_RAM+12

   lda CIA1_SEC
   and #$f0
   lsr  
   lsr 
   lsr 
   lsr
   ora #$30
   sta SCREEN_RAM+11



   lda CIA1_TENTH
}

.macro SetDate(month, day, year)
{
   lda #month
   sta MONTH
   lda #day
   sta DAY
   lda #year
   sta YEAR
}

.macro DisplayDate()
{
   lda MONTH
   and #$0f
   ora #$30
   sta SCREEN_DATE + 1

   lda MONTH
   and #$f0
   lsr  
   lsr 
   lsr 
   lsr
   ora #$30
   sta SCREEN_DATE

   lda DAY
   and #$0f
   ora #$30
   sta SCREEN_DATE+4

   lda DAY
   and #$f0
   lsr  
   lsr 
   lsr 
   lsr
   ora #$30
   sta SCREEN_DATE+3

   lda YEAR
   and #$0f
   ora #$30
   sta SCREEN_DATE+7

   lda YEAR
   and #$f0
   lsr  
   lsr 
   lsr 
   lsr
   ora #$30
   sta SCREEN_DATE+6

}

.macro delaySec(seconds)
{
   // 6502 variable delay routine for 1mhz clock
// call with number of seconds in accumulator (a)
// preserves x and y registers
// uses zero page locations $00 and $01
pha
tya
pha
txa
pha

lda #seconds*3

delay_sec:
    sta $00         // store seconds count
    beq done        // if 0 seconds, exit immediately
    
outer_loop:
    ldx #$ff        // load outer loop count (20 decimal)
    
middle_loop:
    ldy #$ff        // load inner loop count (195 decimal)
    
inner_loop:
    dey             // 2 cycles
    bne inner_loop  // 3 cycles (2 when branch not taken)
    
    dex             // 2 cycles
    bne middle_loop // 3 cycles (2 when branch not taken)
    
    dec $00         // 5 cycles - decrement second counter
    bne outer_loop  // 3 cycles (2 when branch not taken)
    
done:
    pla
    tax
    pla
    tay 
    pla

// timing breakdown per second:
// inner loop: (2+3) * 195 = 975 cycles (last iteration: 2+2 = 4)
// total inner: 974*5 + 4 = 4,874 cycles
// middle loop overhead: (4,874 + 2 + 3) * 20 = 97,580 cycles
// last middle iteration: 4,874 + 2 + 2 = 4,878 cycles
// outer loop: 97,560*5 + 4,878 + 5 + 3 = 1,000,286 cycles
// approximately 1 second at 1mhz (1,000,000 cycles/sec)
}
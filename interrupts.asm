
//---------Interrupt routine
irq:
//jmp $EA31 
//---my code
// .result contains offset number
// .result2 will contain SCR+result
pha
tya
pha
//-----check for CIA based interrupt
lda CIA1_ICR
and #%00000100
cmp #%00000100
bne raster

//SetBorderColor(8)
//sec 
//not working right now jmp inc_day


//-----raster interrupt code
raster:
ldy #37
lda #<result
sta zp_0
lda #>result
sta zp_0 + 1


lda $a2
and #$40
sta FLAG
line_loop:
lda FLAG
bne alt

lda #$07
jmp write_color
alt:
lda #$00

write_color:
sta (zp_0),y

dey
bmi end_irq
jmp line_loop

//-----CIA based interrupt
inc_day:
lda DAY
clc
sed 
adc #$01
sta DAY
cld
//lda #%00000000
//sta CIA1_CRB
//SetCIATOD($91,$59,$50)
//-----set cia to generate interrupt
lda #%10000100
sta CIA1_ICR

//-----debug screen change
lda DAY 
and #$0f
sta $d020




//---done my code

end_irq:
pla
tay
pla
asl $D019            //; acknowledge the interrupt by clearing the VIC's interrupt flag

jmp $EA31 


//------------------------------------------------------------------------------
//----------------------Interrupt wedge from raster
init_irq:
sei                  //; set interrupt bit, make the CPU ignore interrupt requests
lda #%01111111       //; switch off interrupt signals from CIA-1
sta CIA1_ICR



and $D011            //; clear most significant bit of VIC's raster register
sta $D011

sta $DC0D            //; acknowledge pending interrupts from CIA-1
sta $DD0D            //; acknowledge pending interrupts from CIA-2
//-----set cia to generate interrupt
lda #%10000100
sta CIA1_ICR


lda #210            // ; set rasterline where interrupt shall occur
sta $D012

lda #<irq            //; set interrupt vectors, pointing to interrupt service routine below
sta $0314
lda #>irq
sta $0315

lda #%00000001       //; enable raster interrupt signals from VIC
sta $D01A

cli                  //; clear interrupt flag, allowing the CPU to respond to interrupt requests
rts

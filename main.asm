//UAL flight schedule tracker
//James Hughes
//11-25-25

//*= $0801 "Basic Upstart"
BasicUpstart2(start) // 10 sys$0810
//*= $0810 "Program"


.encoding "petscii_upper"
#import "fileList.asm"
#import "constants.asm"
#import "macro.asm"
#import "subroutines.asm"
#import "interrupts.asm"
#import "rs232.asm"


//.segment Code "Main"
start: 
lda #$00
sta FLAG_DAY
SetBorderColor(0)
SetScreenColor(4)
ClearScreen()
PlotXY(12,4)
OutputText(TITLE)

//SetDate($01,$04,$26)

PlotXY(15,23)
OutputText(PRESSKEY)
jsr waitKey
//open comm port to get date and time from server
jsr settmdt


PlotXY(12,12)
OutputText(LOADSCH)
LoadFile(2,FILE_SCHEDULE,12,s_start)

PlotXY(12,14)
OutputText(LOADAIR)

//LoadFile(3,FILE_AIRPORTS,6,$4000)

SetBorderColor(3)
SetScreenColor(0)
ClearScreen()


//switch to dashboard screen
LoadFile(4,FILE_DASHBOARD,8,$0400)

//update flight details
jsr dashboard
//possible clear dashboard
 
//set time for testing purposes and set alarm also
SetCIATOD($06,$33,$50)
//lda #%10000000
//sta CIA1_CRB
//SetCIATOD($12,$00,$00)
//jsr waitKey
jsr init_irq

main:
jsr new_day_check           //looks for 12:00am, INC DAY and fires the FLAG_DAY to prevent repeat increments
jsr reset_day_check_flag    //rearms the FLAG_DAY at 01am hour (once and only once)
jsr calendar_maintenance    //check for max day in given month and rollover
DisplayTOD()
DisplayDate()

//check for 'f2' key
jsr GETIN
cmp #fn_2
//check for break key
jsr STOP
bne continue
rts
continue:
//-----reinforcement as I think Kernal is clearing this
//-----set cia to generate interrupt
//lda #%10000100
//sta CIA1_ICR


jmp main

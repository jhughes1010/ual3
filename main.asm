//UAL flight schedule tracker
//James Hughes
//01-12-26

BasicUpstart2(start)

.encoding "petscii_upper"
#import "fileList.asm"
#import "constants.asm"

start: 
    lda #$00
    sta FLAG_DAY
    SetBorderColor(0)
    SetScreenColor(4)
    ClearScreen()
    PlotXY(12,4)
    OutputText(TITLE)

    PlotXY(15,23)
    OutputText(PRESSKEY)
    jsr waitKey

    //open comm port to get date and time from server
    jsr set_time_date


    PlotXY(12,12)
    OutputText(LOADSCH)
    LoadFile(2,FILE_SCHEDULE,12,s_start)

    PlotXY(12,14)
    OutputText(LOADAIR)

    //TODO LoadFile(3,FILE_AIRPORTS,6,$4000)

    SetBorderColor(3) 
    SetScreenColor(0)
    ClearScreen()

    //switch to dashboard screen
    LoadFile(4,FILE_DASHBOARD,8,$0400)

    //update flight details
    jsr dashboard
    //possible clear dashboard
    jsr init_irq

main:
    jsr new_day_check           //looks for 12:00am, INC DAY and sets the FLAG_DAY to prevent repeat increments
    jsr reset_day_check_flag    //resets the FLAG_DAY at 01am hour (once and only once)
    jsr calendar_maintenance    //check for max day in given month and rollover
    DisplayTOD()
    DisplayDate()

    //check for break key
    jsr STOP
    bne continue
    brk
continue:
    jmp main

#import "macro.asm"
#import "subroutines.asm"
#import "interrupts.asm"
#import "comm_port.asm"


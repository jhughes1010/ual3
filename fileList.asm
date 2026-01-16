
// ----------------- FILE LIST -----------------

// LABEL:                  // FILE NAME:       FILE NUMBER:      CHARS:
//---------------------------------------------------------------------
//							  "MAIN.PRG"          1       
FILE_SCHEDULE:			.text "SCHEDULE.BIN" //      2                9
FILE_AIRPORTS:      .text "SCH RD"  //      3                8
FILE_DASHBOARD:     .text "DASH.BIN"


TITLE: 
  .text "UAL FLIGHT TRACKER"
  .byte 0

PRESSKEY:
  .text "PRESS A KEY"
   .byte 0
 
LOADSCH:
  .text "LOADING SCHEDULE"
   .byte 0

LOADAIR:
  .text "LOADING AIRPORTS"
   .byte 0

COMM_TITLE:
  .text "FLUSHING BUFFER"
  .byte 0

COMM_TELNET:
  .text "CONNECTING TO TIMESERVER"
  .byte 0

COMM_DATE:
  .byte $93
  .text "RETRIEVING DATE"
  .byte 0

REC_MEM:
  .word 0

REC_PTR:
  .byte 0

y_txt:
.byte 0

x_txt:
.byte 0

FLAG_DAY:
.byte 0

FLAG:
.byte 0

FLAG_PM:
.byte 0

COLOR_BAR:
.word SCREEN_COLOR_RAM_SCH
//.byte #<SCREEN_COLOR_RAM_SCH
//.byte #>CREEN_COLOR_RAM_SCH

//get rid of these!!!!
.var num = $0000
.var result = $d969

HOUR:
.byte 0

MINUTE:
.byte 0

SECOND:
.byte 0


// Messages
MSG_CONNECT:
        .text "ATDT192.168.1.253"
        .byte RETURN, $0A, $00

MSG_DTTM:
        .text "DTTM"
        .byte RETURN, $0A, $00


MSG_TIME:
        .text "TIME"
        .byte RETURN, $0A, $00




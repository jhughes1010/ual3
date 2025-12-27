
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

S_REC_LOC:
    .word 0

y_txt:
.byte 0

x_txt:
.byte 0

DAY_FLAG:
.byte 0

FLAG:
.byte 0

//get rid of these!!!!
.var num = $0000
.var result = $d969

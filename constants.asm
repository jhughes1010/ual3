// ----------------- FILE CONSTANTS -----------------

.label SETNAM = $ffbd
.label SETLFS = $ffba
.label LOAD = $ffd5
.label SAVE = $ffd8
.label STOP = $ffe1

.label CHROUT = $ffd2
.label GETIN = $ffe4
.label PLOT = $fff0

.label SETTIM = $ffdb
.label RDTIM = $ffde

.label SCREEN_RAM = $0400
.label SCREEN_COLOR_RAM = $D800

//-----
.label SCREEN_DATE = $0400 + 45

//-----CIA1
.label CIA1_CRB = $dc0f
.label CIA1_ICR = $dc0d
.label CIA1_HOUR = $dc0b
.label CIA1_MIN = $dc0a
.label CIA1_SEC = $dc09
.label CIA1_TENTH = $dc08

//-----cassette buffer usage
.label MONTH = $033C
.label DAY = $033D
.label YEAR = $033E

//-----zero page
.label zp_0 = $fb
.label zp_1 = $fd


//-----schedule record 
.label s_start = $4000
.label s_size = $20
.label s_dep = $04
.label s_dep_size = $03


//special keys
.label fn_1 = $85
.label fn_2 = $89
.label fn_3 = $86
.label fn_4 = $8a
.label fn_5 = $87
.label fn_6 = $8b
.label fn_7 = $88
.label fn_8 = $8c

//date locations on screen memory
.label screenYear = $0402
.label screenMonth = screenYear + 3
.label screenDay = screenYear + 6

//time locations on screen memory
.label screenHour = $040F
.label screenMinute = screenHour + 3
.label screenSecond = screenHour + 6


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

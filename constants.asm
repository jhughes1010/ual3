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
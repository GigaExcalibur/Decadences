.thumb
@draws the stat screen
.include "mss_defs.s"

.global MSS_page1
.type MSS_page1, %function


MSS_page1:

page_start

@load the growth getters onto the stack, if needed
ldr r0,=Growth_Getter_Table
str r0,[sp,#0xC]

ldr r0,=Display_Growth_Options_Link
ldr r0,[r0]
mov r1,#0x10
and r0,r1
mov r1,r8
ldrb r1,[r1,#0xB]
mov r2,#0xC0
tst r1,r2
beq IsPlayerUnit
mov r0,#0
IsPlayerUnit:
str r0,[sp,#0x14]

@draw str or mag
  mov r0, r8
  blh     MagCheck      @r0 = 1 if mag should show
  cmp     r0,#0x0       
  beq     NotMag        
    @draw Mag at 13, 3. colour defaults to yellow.
    draw_textID_at 13, 3, textID=0x4ff, growth_func=2
    b       MagStrDone    
  NotMag:
    @draw Str at 13, 3
    draw_textID_at 13, 3, textID=0x4fe, growth_func=2
  MagStrDone:

draw_textID_at 13, 5, textID=0x4EC, growth_func=3 @skl
draw_textID_at 13, 7, textID=0x4ED, growth_func=4 @spd
draw_textID_at 13, 9, textID=0x4ee, growth_func=5 @luck
draw_textID_at 13, 11, textID=0x4ef, growth_func=6 @def
draw_textID_at 21, 3, textID=0x4f0, growth_func=7 @res

b 	LiteralJump1
.ltorg 
LiteralJump1:

ldr		r0,=StatScreenStruct
sub		r0,#1
mov		r1,r8
ldrb	r1,[r1,#0xB]
mov		r2,#0xC0
tst		r1,r2
beq		Label2
ldrb	r1,[r0]
mov		r2,#0xFE
and		r1,r2
strb	r1,[r0]			@don't display enemy growths
Label2:
ldrb	r0,[r0]
mov		r1,#1
tst		r0,r1
beq		ShowStats
b		ShowGrowths

ShowStats:
b ShowStats2

.ltorg
.align
ShowGrowths: @things in this section are only drawn when in growths mode

ldr		r0,[sp,#0xC]
ldr		r0,[r0,#4]		@str growth getter
draw_growth_at 18, 3
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#8]		@skl growth getter
draw_growth_at 18, 5
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#12]		@spd growth getter
draw_growth_at 18, 7
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#16]		@luk growth getter
draw_growth_at 18, 9
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#20]		@def growth getter
draw_growth_at 18, 11
ldr		r0,[sp,#0xC]
ldr		r0,[r0,#24]		@res growth getter
draw_growth_at 18, 13
ldr		r0,[sp,#0xC]
ldr		r0,[r0]			@hp growth getter (not displaying because there's no room atm)
draw_growth_at 18, 15
draw_textID_at 13, 15, textID=0x4E9, growth_func=1 @hp name

b		literalJump2
.ltorg

ShowStats2: @things in this section are only drawn when not in growths mode

@draw_stats_box

  ldr     r0, =SSS_Flag
  ldr     r0, [r0]
  cmp     r0, #0x0
  beq     DefaultBox
    ldr     r0, =SSS_StatsBoxTSA
    b       DecompressBoxTSA
  DefaultBox:
    ldr     r0, =#0x8A02204   @box TSA
  DecompressBoxTSA:
  ldr     r4, =gGenericBuffer
  mov     r1, r4
  blh     Decompress
  ldr     r0, =#0x20049EE     @somewhere on the bgmap
  mov     r2, #0xC1
  lsl     r2, r2, #0x6
  mov     r1, r4
  blh     BgMap_ApplyTsa
  ldr     r0, =#0x8205A24     @map of text labels and positions
  blh     DrawStatscreenTextMap
  ldr     r6, =StatScreenStruct
  ldr     r0, [r6, #0xC]
  ldr     r0, [r0, #0x4]
  ldrb    r0, [r0, #0x4]
  
  draw_textID_at 14, 13, 0x0558, 3 @ Power
  draw_textID_at 14, 15, 0x04F4, 3 @ HitText
  draw_textID_at 14, 17, 0x0501, 4 @ Crit
  draw_textID_at 21, 13, 0x0504, 3 @ Attack speed
  draw_textID_at 21, 15, 0x04F5, 3 @ Avo
  draw_textID_at 21, 17, 0x567, 4 @ Crit Avo
  
  ldr     r4, =#0x200407C     @bgmap offset
  ldr     r6, =gActiveBattleUnit
  
  @Power
  mov     r0, #0x5A
  ldsh    r0, [r6, r0]
  draw_number_at 20, 13
  
  @Hit
  mov     r0, #0x60
  ldsh    r0, [r6, r0]
  draw_number_at 20, 15
  
  @Crit
  mov     r0, #0x66
  ldsh    r0, [r6, r0]
  draw_number_at 20, 17
  
  @AS
  mov     r0, #0x5E
  ldsh    r0, [r6, r0]
  draw_number_at 27, 13
  
  @Avo
  mov     r0, #0x62
  ldsh    r0, [r6, r0]
  draw_number_at 27, 15
  
  @Crit Avo
  mov     r0, #0x68
  ldsh    r0, [r6, r0]
  draw_number_at 27, 17
  
  /* mov     r0, r6
  add     r0, #0x5A         @load battle atk
  mov     r1, #0x0
  ldsh    r2, [r0, r1]
  mov     r0, r4
  mov     r1, #0x2
  blh     DrawDecNumber
  mov     r0, r4
  add     r0, #0x80
  mov     r1, r6
  add     r1, #0x60         @load battle hit
  mov     r3, #0x0
  ldsh    r2, [r1, r3]
  mov     r1, #0x2
  blh     DrawDecNumber
  mov     r0, r4
  add     r0, #0xE
  mov     r1, r6
  add     r1, #0x66         @load battle crit
  mov     r3, #0x0
  ldsh    r2, [r1, r3]
  mov     r1, #0x2
  blh     DrawDecNumber
  add     r4, #0x8E
  mov     r0, r6
  add     r0, #0x62         @load battle avoid
  mov     r6, #0x0
  ldsh    r2, [r0, r6]
  mov     r0, r4
  mov     r1, #0x2
  blh     DrawDecNumber */

draw_str_bar_at 16, 3
draw_skl_bar_at 16, 5
draw_spd_bar_at 16, 7
draw_luck_bar_at 16, 9
draw_def_bar_at 16, 11

draw_textID_at 21, 9, 0x4f6 @move
draw_move_bar_with_getter_at 24, 9
@draw_move_bar_with_getter_at 16, 15

b literalJump2

.ltorg
.align

literalJump2:

draw_res_bar_at 24, 3
draw_con_bar_with_getter_at 24, 5
draw_textID_at 21, 5, textID=0x4f7 @con

draw_textID_at 21, 7, textID=0x4f8 @aid
draw_number_at 25, 7, 0x80189B8, 2 @aid getter
draw_aid_icon_at 26, 7

@ draw_trv_text_at 21, 5

@draw_textID_at 21, 7, textID=0x4f1 @affin
@draw_affinity_icon_at 24, 7

@ draw_status_text_at 21, 9

b exitVanillaStatStuff

.ltorg
.align

exitVanillaStatStuff:

ldr r0,=TalkTextIDLink
ldrh r0,[r0]
draw_talk_text_at 21, 11

@ draw_textID_at 13, 15, textID=0x4f6 @move
@ draw_move_bar_at 16, 15

@blh DrawBWLNumbers

ldr		r0,=StatScreenStruct
sub		r0,#0x2
ldrb	r0,[r0]
cmp		r0,#0x0
beq		DoNotUpdate
ldr		r0,=BgBitfield
ldrb	r1,[r0]
mov		r2,#0x5
orr		r1,r2
strb	r1,[r0]
ldr		r0,=BgMapFillRect
mov		r14,r0
ldr		r0,=Const_2003D2C
ldr		r1,=Const_2022D40
mov		r2,#0x12
mov		r3,#0x12
.short	0xF800
ldr		r0,=BgMapFillRect
mov		r14,r0
ldr		r0,=Const_200472C
ldr		r1,=Const_2023D40
mov		r2,#0x12
mov		r3,#0x12
.short	0xF800
ldr		r0,=StatScreenStruct
sub		r0,#0x2
mov		r1,#0x0
strb	r1,[r0]

b DoNotUpdate
.ltorg

DoNotUpdate:
page_end

.ltorg

Restore_Palette:
@r0=thing to store back, r1=0 if we can skip this
cmp		r1,#0
beq		RestoreDone
cmp		r0,#0
beq		RestoreDone
ldr		r1,=#0x02028E70
ldr		r1,[r1]
strh	r0,[r1,#0x10]
RestoreDone:
bx		r14

.ltorg

.include "GetTalkee.s"


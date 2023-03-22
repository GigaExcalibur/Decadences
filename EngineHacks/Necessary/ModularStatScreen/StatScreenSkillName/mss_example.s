@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Default MSS formatting of skill icons (the positions are different but the format is the same)
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ldr r0,=SkillsTextIDLink
ldrh r0, [r0]
draw_textID_at 21, 3, colour=White @skills

.set NoAltIconDraw, 1 @this is the piece that makes them use a separate sheet
mov r0, r8
ldr r1, =Skill_Getter
mov lr, r1
.short 0xf800 @skills now stored in the skills buffer

mov r6, r0
ldrb r0, [r6] 
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 21, 5

ldrb r0, [r6,#1]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 21, 7

ldrb r0, [r6, #2]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 21, 9

ldrb r0, [r6, #3]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 21, 11

ldrb r0, [r6, #4]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 21, 13

ldrb r0, [r6, #5]
cmp r0, #0
beq SkillEnd
draw_skill_icon_at 21, 15

SkillEnd:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Formatting for skill names, designed to match that of skill icons as much as possible. Also meant to be located in exactly this spot, after the skill icons are drawn. It probably works elsewhere, but I know it works here lol
@The only different is the need for a SkillNameHalfway label, as SkillNameEnd is out of beq range for the first three macros. This is not a pretty workaround but it works.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@Get skills in buffer
mov r0, r8
ldr r1, =Skill_Getter
mov lr, r1
.short 0xf800 @skills now stored in the skills buffer
mov r6, r0

ldrb r0, [r6, #0] 
cmp r0, #0
beq SkillNameHalfway
draw_skill_name_at 23, 5, colour=White

ldrb r0, [r6, #1] 
cmp r0, #0
beq SkillNameHalfway
draw_skill_name_at 23, 7, colour=White

ldrb r0, [r6, #2] 
cmp r0, #0
beq SkillNameHalfway
draw_skill_name_at 23, 9, colour=White

SkillNameHalfway:
cmp r0, #0
beq SkillNameEnd

ldrb r0, [r6, #3] 
cmp r0, #0
beq SkillNameEnd
draw_skill_name_at 23, 11, colour=White 

ldrb r0, [r6, #4] 
cmp r0, #0
beq SkillNameEnd
draw_skill_name_at 23, 13, colour=White 

ldrb r0, [r6, #5] 
cmp r0, #0
beq SkillNameEnd
draw_skill_name_at 23, 15, colour=White 

SkillNameEnd:
page_end


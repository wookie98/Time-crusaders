;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of Combat tendency: An Amstrad fight game
;;  Copyright (C) 2019 Alfred Gomez Vicent and David Amaro Galvañ Sala (emails: davidse8@gmail.com, alfred.gomez@outlook.com)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  See <http://www.gnu.org/licenses/> for more information.
;;-------------------------------------------------------------------------------
.include "man/entity_manager.h.s"
.include "cmp/entity.h.s"
.include "sys/sprite_system.h.s"
.include "cmp/array_structure.h.s"

f_sprites2:DefineCmp_Sprites f_stance,f_guard,f_duck,f_jump,f_punch,f_kick,f_low_punch,f_low_kick,f_superman,f_jump_kick,f_duck_guard,f_tkdmg,f_moving,f_ko,f_winner;;Aqui en vez de stance ira moving
sprites2:DefineCmp_Sprites _stance,_guard,_duck,_jump,_punch,_kick,_low_punch,_low_kick,_superman,_jump_kick,_duck_guard,_tkdmg,_stance,_ko,_winner
;sprites:DefineCmp_Sprites _sprite_stance,_sprite_stance,_sprite_stance,_sprite_jump,_sprite_punch,_sprite_stance,_sprite_stance,_sprite_stance,_sprite_stance,_sprite_stance,_sprite_stance,_sprite_stance,_sprite_stance
;f_sprites:DefineCmp_Sprites _sprite_f_stance,_sprite_f_stance,_sprite_f_stance,_sprite_f_jump,_sprite_f_punch,_sprite_f_stance,_sprite_f_stance,_sprite_f_stance,_sprite_f_stance,_sprite_f_stance,_sprite_f_stance,_sprite_f_tkdmg,_sprite_f_stance
Width:DefineCmp_ActionBasedParameters 8,8,12,8,12,16,12,12,12,12,12,8,8,8,16

sys_action_update::
	call sys_action_player
	call sys_action_foe
	ret

sys_action_player::

	ld a,e_actcd(ix)
	cp #0
	jr nz,dec_cd		;;cd no 0, no cambia
	ld a,e_nxtaction(ix)
	cp #0
	jr nz,nextaction0		;;
	ld e_action(ix),#stance
	ld hl,#_sprite_stance
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0
	ld e_change(ix),#1
	jr end_ent
	nextaction0:
	call nextaction1
;;change action
dec_cd:
	dec e_actcd(ix)
	ld e_change(ix),#0
end_ent:
	ret

sys_action_foe::

	ld a,f_actcd(ix)
	cp #0
	jr nz,f_dec_cd		;;cd no 0, no cambia
	ld a,f_nxtaction(ix)
	cp #0
	jr nz,f_nextaction0		;;

	ld iy,#Width
	ld c,a
	ld b,#0 
	add iy,bc
	ld a,(iy)
	ld c,f_w(ix)
	sub c
	ld c,a
	ld a,f_vx(ix)
	sub c
	ld f_vx(ix),a
	

	ld f_action(ix),#stance
	ld hl,#_sprite_f_stance
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#8
	ld f_hit(ix),#0
	ld f_change(ix),#1
	;

	jr f_end_ent
	f_nextaction0:
	call f_nextaction1
	

;;change action
f_dec_cd:
	dec f_actcd(ix)
	;;ld f_change(ix),#0
f_end_ent:
	ret
;	ld d,f_x(ix)
;	add d
;	ld f_x(ix),a
;	ld e,f_w(ix)
;
;	ld f_w(ix),c
;	ld a,f_action(ix)
;	add a

nextaction1::
	ld e_change(ix),#1
	ld c,a
	ld d,a
	add a
	ld iy, #sprites2
	ld c,a
	ld b,#0
	add iy,bc
	ld h,1(iy)
	ld l,(iy)
	
	jp (hl)
	




	;;ld iy,#sprites2
	;;;ld a,e_action(ix)
	;;ld e_nxtaction(ix),#stance
	;;add a
	;;ld c,a
	;;ld b,#0
	;;add iy,bc
	;;ld h,1(iy)
	;;ld l,(iy)
	;;jp (hl)
_stance:
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#stance
	ld hl,#_sprite_stance
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0

	;ld iy,#Width
	;;ld c,a
	;ld b,#0 
	;add iy,bc
	;ld a,(iy)
	;ld c,f_w(ix)
	;sub c
	;;ld f_vx(ix),a
	;add d
	;ld f_x(ix),a
	

	ret
_guard:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#guard
	ld hl,#_sprite_guard
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0
	ld e_actcd(ix),#100
	ret
_duck:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#duck
	ld hl,#_sprite_duck
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#12
	ld e_hit(ix),#0
	ld e_actcd(ix),#5
	ret
_jump:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#jump
	ld hl,#_sprite_jump
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0
	ld e_actcd(ix),#30
	ret
_punch:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#punch
	ld hl,#_sprite_punch
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#12
	ld e_hit(ix),#0
	ld e_actcd(ix),#25
	ret
_kick:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#kick
	ld hl,#_sprite_kick
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#16
	ld e_hit(ix),#0
	ld e_actcd(ix),#30
	ret
_low_punch:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#low_punch
	ld hl,#_sprite_low_punch
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#12
	ld e_hit(ix),#0
	ld e_actcd(ix),#30
	ret
_low_kick:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#low_kick
	ld hl,#_sprite_low_kick
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#12
	ld e_hit(ix),#0
	ld e_actcd(ix),#35
	ret
_superman:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#superman
	ld hl,#_sprite_superman
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#12
	ld e_hit(ix),#0
	ld e_actcd(ix),#20
	ret
_jump_kick:	
	ld e_nxtaction(ix),#stance
	ld e_action(ix),#jump_kick
	ld hl,#_sprite_jump_kick
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#12
	ld e_hit(ix),#0
	ld e_actcd(ix),#20
	ret
_duck_guard:
	ld e_nxtaction(ix),#duck
	ld e_action(ix),#duck_guard
	ld hl,#_sprite_duck_guard
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#12
	ld e_hit(ix),#0
	ld e_actcd(ix),#100
	ret
_tkdmg:
	ld a,e_y(ix)
	cp #169
	jr nz, dmg2jump
	ld e_nxtaction(ix),#stance
	jr contDmg
	dmg2jump:
	ld e_nxtaction(ix),#jump
	contDmg:
	ld e_action(ix),#tkdmg
	ld hl,#_sprite_tkdmg
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0
	ld e_actcd(ix),#15
	ld e_change(ix),#1
ret
_ko:
	ld e_nxtaction(ix),#KO
	ld e_action(ix),#KO
	ld hl,#_sprite_duck
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0
	ld e_actcd(ix),#100
	ret
_winner:
	ld e_nxtaction(ix),#winner
	ld e_action(ix),#winner
	ld hl,#_sprite_kick
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0
	ld e_actcd(ix),#100
	ret


f_nextaction1::
	ld f_change(ix),#1
	ld iy,#Width
	ld c,a
	ld d,a
	ld b,#0 
	add iy,bc
	ld a,(iy)
	ld c,f_w(ix)
	sub c
	ld c,a
	ld a,f_x(ix)
	sub c
	ld f_x(ix),a

	ld a,f_nxtaction(ix)
	add a
	ld iy, #f_sprites2
	ld c,a
	ld b,#0
	add iy,bc
	ld h,1(iy)
	ld l,(iy)
	
	jp (hl)

f_stance:
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#stance
	ld hl,#_sprite_f_stance
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#8
	ld f_hit(ix),#0
	ret
f_guard:
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#guard
	ld hl,#_sprite_f_guard
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#8
	ld f_hit(ix),#0
	ld f_actcd(ix),#100
	ret
f_duck:	
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#duck
	ld hl,#_sprite_f_duck
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#12
	ld f_hit(ix),#0
	ld f_actcd(ix),#5
	ret
f_jump:	
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#jump
	ld hl,#_sprite_f_jump
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#8
	ld f_hit(ix),#0
	ld f_actcd(ix),#30
	ret
f_punch:	
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#punch
	ld hl,#_sprite_f_punch
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#12
	ld f_hit(ix),#0
	ld f_actcd(ix),#25
	ret
f_kick:	
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#kick
	ld hl,#_sprite_f_kick
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#16
	ld f_hit(ix),#0
	ld f_actcd(ix),#30
	ret
f_low_punch:	
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#low_punch
	ld hl,#_sprite_f_low_punch
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#12
	ld f_hit(ix),#0
	ld f_actcd(ix),#30
	ret
f_low_kick:	
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#low_kick
	ld hl,#_sprite_f_low_kick
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#12
	ld f_hit(ix),#0
	ld f_actcd(ix),#35
	ret
f_superman:	
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#superman
	ld hl,#_sprite_f_superman
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#12
	ld f_hit(ix),#0
	;ld f_actcd(ix),#20
	ret
f_jump_kick:	
	ld f_nxtaction(ix),#stance
	ld f_action(ix),#jump_kick
	ld hl,#_sprite_f_jump_kick
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#12
	ld f_hit(ix),#0
	;ld f_actcd(ix),#20
	ret
f_duck_guard:
	ld f_nxtaction(ix),#duck
	ld f_action(ix),#duck_guard
	ld hl,#_sprite_f_duck_guard
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#12
	ld f_hit(ix),#0
	ld f_actcd(ix),#100
	ret
f_tkdmg:
	ld a,f_y(ix)
	cp #169
	jr nz, f_dmg2jump
	ld f_nxtaction(ix),#stance
	jr f_contDmg
	f_dmg2jump:
	ld f_nxtaction(ix),#jump
	f_contDmg:
	ld f_action(ix),#tkdmg
	ld hl,#_sprite_f_tkdmg
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#8
	ld f_hit(ix),#0
	ld f_actcd(ix),#15
	ret
f_moving:
	ld f_action(ix),#moving
	ld hl,#_sprite_f_stance
	ld f_sprite_l(ix),l
	ld f_sprite_h(ix),h
	ld f_w(ix),#8
	ld f_hit(ix),#0
	ld f_actcd(ix),#-1
	ret
f_ko:
	ld e_nxtaction(ix),#KO
	ld e_action(ix),#KO
	ld hl,#_sprite_duck
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0
	ld e_actcd(ix),#100
	ret
f_winner:
	ld e_nxtaction(ix),#winner
	ld e_action(ix),#winner
	ld hl,#_sprite_kick
	ld e_sprite_l(ix),l
	ld e_sprite_h(ix),h
	ld e_w(ix),#8
	ld e_hit(ix),#0
	ld e_actcd(ix),#100
	ret

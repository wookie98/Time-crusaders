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
.include "sys/fight_system.h.s"
;.include "man/entity.h.s"
.include "cmp/array_structure.h.s"
.include "cpctelera.h.s"
.include "cmp/entity.h.s"
.module entity_fight_manager

;DefineComponentPointersArrayStructure_Size _fight, max_entities
;
;f_sprites2:DefineCmp_Sprites f_stance,f_guard,f_duck,f_jump,f_punch,f_kick,f_superman,f_jump_kick,f_low_punch,f_low_kick
action:DefineCmp_Sprites _stance,_guard,_duck,_jump,_punch,_kick,_low_punch,_low_kick,_superman,_jump_kick,_duck_guard,_tkdmg,_stance,_stance,_stance;;Aqui ira el sprite moving
action2:DefineCmp_Sprites f_stance,f_guard,f_duck,f_jump,f_punch,f_kick,f_low_punch,f_low_kick,f_superman,f_jump_kick,f_duck_guard,f_tkdmg,f_stance,f_stance,f_stance;;Aqui ira el sprite moving
;;sys_fight_init::
Dmg:DefineCmp_ActionBasedParameters 0,0,0,0,20,20,10,13,20,20,0,0,0,0,0
;;ret

;man_entity_fight_init::
;	ld hl,#_fight_ptr_array
;	ld (_fight_ptr_pend),hl
;	xor a
;	ld (hl),a
;	ld d,h
;	ld e,l
;	ld bc,#2*max_entities-1
;	ldir
;
;man_entity_fight_getArrayHL::
;	ld hl,#_fight_ptr_array
;	ret
;
;man_entity_fight_add::
;	ld hl,(_fight_ptr_pend)
;	ld__a_ixl
;	ld (hl),a
;	inc hl
;	ld__a_ixh
;	ld (hl),a
;
;	inc hl
;	ld(_fight_ptr_pend),hl
;	ret
;sys_fight_update::
;
;_fight_array_ptr=.+1
;	ld hl,0x0000
;_loop:
;
;ld e,(hl)
;inc hl
;ld d,hl
;inc hl
;
;ld__ixl_e
;ld_ixh_d
;
;ld e,(hl)
;inc hl
;ld d,(hl)
;ld__ixl_e
;ld_ixh_d

sys_fight_check::
ld a,e_x(ix)
add e_w(ix);works for size of 8
sub #4		;this is to make sure the hit reaches the foe and doesn't justhit the area 
sub f_x(ix)
;add e_w(ix);works for size of 32 foe
;sub #16		;this is to make sure the hit reaches the foe and doesn't justhit the area 
;sub f_x(ix)

jr c,_no_hit

ld a,e_hit(ix)
or a
jr nz, check_f_hit
;ld a,f_x(ix) para pto gordo creo que no es necesario
;add f_w(ix)
;add #4
;sub e_x(ix)
;jr c, _no_hit
call hit
check_f_hit:
ld a,f_hit(ix)
or a
jr nz, _no_hit

call foe_hit
;ld a, f_lp(ix)
;sub #1
;jr c,victory_animation
;ld a, e_lp(ix)
;sub #1
;jr c,defeat_animation
jr _no_hit

;defeat_animation:
;ld a,#0xFF
;ld (0xD000),a
;ld f_actcd(ix),#0
;ld f_nxtaction(ix),#winner
;ld e_actcd(ix),#0
;ld e_nxtaction(ix),#KO
;;;ld	 a, #81 ;;
;;;sub	 #8					;;Restamos 8 porque es el tamano normal
;;;ld	 c, a
;;;ld	 a, e_x(ix)
;;;add	 #-32
;;;cp 	 c
;;;jr	nc, invalid_x
;;;ld e_x(ix),a
;;;ld e_vy(ix),#-3
;invalid_x:
;
;
;
;jr _no_hit
;victory_animation:
;  ld a,#0xFF
;   ld (0xC000),a
;;;ld f_actcd(ix),#0
;ld f_nxtaction(ix),#winner
;;;ld e_actcd(ix),#0
;ld e_nxtaction(ix),#KO

_no_hit:

ret

hit::
	ld a,e_action(ix)
	add a
	ld iy, #action
	ld c,a
	ld b,#0
	add iy,bc
	ld h,1(iy)
	ld l,(iy)
	jp (hl)
_duck_guard:
_tkdmg:
_stance:
_guard:	
_duck:	
_jump:	
ret
_punch:
ld a,f_action(ix)
cp #guard
jr z,_good_guard
cp #duck
jr z,_stance
cp #duck_guard
jr z,_stance
cp #low_punch
jr z,_stance
cp #low_kick
jr z,_stance
jr damage

_kick:
ld a,f_action(ix)
cp #guard
jr z,_good_guard
cp #jump
jr z,_stance
cp #superman
jr z,_stance
cp #jump_kick
jr z,_stance
cp #duck_guard
jr z,_good_guard
jr damage

_low_punch:
ld a,f_action(ix)
cp #jump
jr z,_stance
cp #superman
jr z,_stance
cp #jump_kick
jr z,_stance
cp #duck_guard
jr z,_good_guard
jr damage

_low_kick:
ld a,f_action(ix)
cp #jump
jr z,_stance
cp #superman
jr z,_stance
cp #jump_kick
jr z,_stance
cp #duck_guard
jr z,_good_guard
jr damage

_good_guard:
	ld f_actcd(ix),#5
	ld e_hit(ix),#1
	ret

_superman:
ld a,f_action(ix)
cp #guard
jr z,_good_guard
cp #duck
jr z,_stance
cp #duck_guard
jr z,_stance
cp #low_punch
jr z,_stance
cp #low_kick
jr z,_stance
jr damage

_jump_kick:
ld a,f_action(ix)
cp #guard
jr z,_good_guard
cp #duck
jr z,_stance2
cp #duck_guard
jr z,_stance2
cp #low_punch
jr z,_stance2
cp #low_kick
jr nz, damage
ret
_stance2:;si no hago esto por motivos que desconozco no compila
ret
damage:	
ld c,e_action(ix)
ld iy,#Dmg
ld b,#0
add iy,bc
ld c,(iy)	;load the damage in c
ld a,f_lp(ix)
sub c
ld f_lp(ix),a
ld e_hit(ix),#1

ld f_nxtaction(ix),#tkdmg
ld f_vx(ix),#2
ld f_actcd(ix),#0

ret



foe_hit::
	ld a,f_action(ix)
	add a
	ld iy, #action2
	ld c,a
	ld b,#0
	add iy,bc
	ld h,1(iy)
	ld l,(iy)
	jp (hl)
f_duck_guard:
f_tkdmg:
f_stance:
f_guard:	
f_duck:	
f_jump:	
ret
f_punch:
ld a,e_action(ix)
cp #guard
jr z,f_good_guard
cp #duck
jr z,f_stance
cp #low_punch
jr z,f_stance
cp #low_kick
jr z,f_stance
cp #duck_guard
jr z,f_stance
jr f_damage

f_kick:
ld a,e_action(ix)
cp #guard
jr z,f_good_guard
cp #jump
jr z,f_stance
cp #superman
jr z,f_stance
cp #jump_kick
jr z,f_stance
cp #duck_guard
jr z,f_good_guard
jr f_damage

f_low_punch:
ld a,e_action(ix)
cp #jump
jr z,f_stance
cp #superman
jr z,f_stance
cp #jump_kick
jr z,f_stance
cp #duck_guard
jr z,f_good_guard
jr f_damage

f_low_kick:
ld a,e_action(ix)
cp #jump
jr z,f_stance
cp #superman
jr z,f_stance
cp #jump_kick
jr z,f_stance
cp #duck_guard
jr z,f_good_guard
jr f_damage

f_good_guard:
ld e_actcd(ix),#5
ld f_hit(ix),#1
ret

f_superman:
ld a,e_action(ix)
cp #guard
jr z,f_good_guard
cp #duck
jr z,f_stance
cp #low_punch
jr z,f_stance
cp #low_kick
jr z,f_stance
cp #duck_guard
jr z,f_stance
jr f_damage

f_jump_kick:
ld a,e_action(ix)
cp #guard
jr z,f_good_guard
cp #duck_guard
jr z,f_stance2
cp #duck
jr z,f_stance2
cp #low_punch
jr z,f_stance2
cp #low_kick
jr nz, f_damage
ret

f_stance2:
ret

f_damage:	
ld c,f_action(ix)
ld iy,#Dmg
ld b,#0
add iy,bc
ld c,(iy)	;load the damage in c
ld a,e_lp(ix)
sub c
ld e_lp(ix),a
ld f_hit(ix),#1

ld e_nxtaction(ix),#tkdmg
ld e_vx(ix),#-2
ld e_actcd(ix),#0

ret




;;----------------------------------------------------------------------------------------------------old version
;;;dmg against foei
;;ld c,e_action(ix)
;;ld iy,#Dmg
;;ld b,#0
;;add iy,bc
;;ld c,(iy)	;load the damage in c
;;ld a,f_lp(ix)
;;sub c
;;ld f_lp(ix),a
;;ld e_hit(ix),#1
;;cp c;comprobaciones tontas como diria mi compañero
;;jr nz,dmg_foe
;;ret
;;;ld f_action(ix),#tkdmg
;;;ld f_vy(ix),#0
;;;ld f_x(ix),#70
;;;ld f_actcd,#10
;;
;;;damage against player
;;dmg_foe:;esta aqui por debuggear
;;ld b,f_action(ix)
;;ld iy,#Dmg
;;ld c,a
;;ld b,#0
;;add iy,bc
;;ld c,(iy)	;load the damage in c
;;ld a,e_lp(ix)
;;sub c
;;ld e_lp(ix),a
;;ld f_hit(ix),#1
;;
;;;ld ek_action(ix),#tkdmg
;;;ld e_vy(ix),#0
;;;ld e_x(ix),#70
;;;ld e_actcd,#10
;;
;;ld a,f_lp(ix)
;;inc a
;;ld c,#2
;;cp c
;;;jr m, victory_animation
;;jr c, victory_animation
;;ld a,e_lp(ix)
;;;jr m, defeat_animation
;;  jr _no_hit 
;;defeat_animation:
;;victory_animation:
;;   ld a,#0xFF
;;   ld (0xC000),a
;;_no_hit:
;;
;;ret
;;
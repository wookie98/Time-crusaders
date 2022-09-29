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
;;
;;	PHYSICS SYSTEM
;;

	.include "man/entity_manager.h.s"
	.include "cmp/entity.h.s"

;;=============================================================
;; Physics System Constants
screen_width	=  80
screen_height	= 200

;;
;; Initializes the physics system
;;
sys_physics_init::
	ld (_ptr_to_entities), de	;;Aqui guarda la direccion de memoria al puntero de entidades
	ld (_num_entities), bc		;;Aqui guarda la direccion de memoria al numero de entidades
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_PHYSICS::Update
;; Updates all physics components of entities
;; Assunes that exist at least one entity in the array 
;; and also assumes that the entities are correct.
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, IX
;; STACK USE: 2 bytes
;;
sys_physics_update::

_ptr_to_entities = . + 2
	ld 	ix, #0x0000					;;Aqu se carga la direccion de memoria al puntero de entidades

_num_entities = . + 1
	ld	a,	(#0x0000)					;;Aqui se carga la direccion de memoria al numero de entidades

;_update_loop:
	
	;; UPDATE X
	ld	 a, #screen_width + 1 ;;
	sub	 #8					;;Restamos 8 porque es el tamano normal
	ld	 c, a

	ld	 a, e_x(ix)
	add	 e_vx(ix)
	cp 	 c
	jr	nc, invalid_x
;valid_x:
	ld  e,a
	ld  a,sizeof_e(ix)
	;inc a
	sub	#8;add con 32
	ld	 c, a

	ld	 a, e_x(ix)
	add	 e_vx(ix)
	ld 	b, 	e_vx(ix)
	cp 	b
	jr 	c,	valid_x
	
	cp 	c
	jr 	z, 	valid_x
	jr	nc, invalid_x ;jr	z, f_valid_x
	;jr f_invalid_x
	ld a,c
	add #8
	cp #8
	jr c,invalid_x
valid_x:
	ld  a,e
	ld	e_x(ix), a
	jr	endif_x
invalid_x:
	ld	a, e_vx(ix)
	xor a
	ld 	e_vx(ix), a
endif_x:
	ld e_vx(ix),#0
	;; UPDATE Y


	;;ld	 a, #screen_height + 1 ;;Mira si sale de la pantalla en eje y
	;;sub	 e_h(ix)
	;ld a,#169 ;;;200-ey_h
	ld	 c, #169
	ld	 a, e_y(ix)
	add	 e_vy(ix)
	;cp 	 c
	;jr z,endif_y
	cp 	 c
	jr	nc, invalid_y
valid_y:
	ld	e_y(ix), a
	ld  a, e_action(ix)
	cp #superman
	jr	z, update_jump 	;;Comprueba si esta saltando
	cp #jump
	jr	z, update_jump 	;;Comprueba si esta saltando
	cp #jump_kick
	jr	z, update_jump 	;;Comprueba si esta saltando
	cp #low_punch
	jr	z, update_jump 	;;Comprueba si esta saltando
	cp #tkdmg
	jr	z, update_jump 	;;Comprueba si esta saltando
	

	jr 	endif_y
invalid_y:
	ld	a, e_vy(ix)
	xor a
	ld 	e_vy(ix), a
	ld	a, e_action(ix)
	cp #3
	jr nz,endif_y
	xor a
	ld 	e_action(ix), a
	ld e_actcd(ix),a
	;ld	 a, #screen_height + 1 
	;sub	 e_h(ix)
	ld e_y(ix),#169
	jr 	endif_y
update_jump:
	ld	a, e_vy(ix)
	inc a
	ld 	e_vy(ix), a
	jr	endif_y
endif_y:
	ld e_vx(ix),#0
	;dec	b
;	;ret	z
;
	;ld	de, #sizeof_e
	;add	ix, de
	;jr	_update_loop
	;ret

sys_physics_move_foe::

	;ld	b, a

;_update_loop:
	;; UPDATE X
	ld	 a, #screen_width + 1 ;;
	sub	 #8
	ld	 c, a

	ld	 a, f_x(ix)
	add	 f_vx(ix)
	cp 	 c
	jr	nc, f_invalid_x
;f_valid_x:
	ld  e,a
	ld  a,(ix);;sizeof_e
	add e_w(ix);;
	;sub #8;;
	;inc a
	sub	 sizeof_e(ix);;f_w
	;dec a
	;sub	 e_w(ix)
	ld	 c, a

	ld	a, f_x(ix)
	add	f_vx(ix)
	ld 	b, 	f_vx(ix)
	cp 	b
	jr 	nc,	f_valid_x
	
	cp 	c
	jr 	z, 	f_valid_x
	jr	nc, f_invalid_x ;jr	z, f_valid_x
	;jr f_invalid_x
f_valid_x:
	ld  a,e
	ld	f_x(ix), a
	jr	f_endif_x
f_invalid_x:
	ld	a, f_vx(ix)
	xor a
	ld 	f_vx(ix), a
f_endif_x:
	ld 	f_vx(ix), #0
;; UPDATE Y


	ld	 c, #169	
	ld	 a, f_y(ix)
	add	 f_vy(ix)
	cp 	 c
	jr z,endif_y_stance
	cp 	 c
	jr	nc, f_invalid_y
f_valid_y:
	ld	f_y(ix), a
	ld  a, f_action(ix)
	cp #superman
	jr	z, f_update_jump 	;;Comprueba si esta saltando
	cp #jump
	jr	z, f_update_jump 	;;Comprueba si esta saltando
	cp #jump_kick
	jr	z, f_update_jump 	;;Comprueba si esta saltando
	cp #tkdmg
	jr	z, f_update_jump 	;;Comprueba si esta saltando
	

	jr 	f_endif_y
f_invalid_y:
	ld	a, f_vy(ix)
	xor a
	ld 	f_vy(ix), a
	ld	a, f_action(ix)
	cp #3
	jr z,f_stance
	cp #superman
	jr z,f_stance
	cp #jump_kick
	jr z,f_stance
	cp #tkdmg
	jr z,f_stance
	

	jr f_endif_y

f_stance:
	xor a
	ld 	f_action(ix), a
	ld 	f_actcd(ix),a
	ld	 a, #169
	ld  f_y(ix),a
	;ld f_y(ix),#120
	jr 	f_endif_y
f_update_jump:
	ld	a, f_vy(ix)
	inc a
	ld 	f_vy(ix), a
	jr	f_endif_y
f_endif_y:

	ld 	f_vx(ix), #0
	ld 	e_vx(ix), #0

	ret
	
endif_y_stance:
	ld a,f_action(ix)
	cp #3
	jr z,f_stance
	cp #8
	jr z,f_stance
	cp #9
	jr z,f_stance
	
	ret
	;dec	b
	;ret	z
;
;	;ld	de, #sizeof_e
;	;add	ix, de
	;jr	_update_loop

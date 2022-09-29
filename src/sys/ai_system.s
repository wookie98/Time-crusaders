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
;;	AI SYSTEM
;;

	.include "cmp/entity.h.s"
	.include "cpct_functions.h.s"
	.include "cmp/array_structure.h.s"

;;=============================================================================================================
;; AI System Constants
time_thinking:	.db	0
planning:		.db 0
switch: DefineCmp_Sprites _random_action, against_guard, against_duck, against_jump, against_punch, against_kick, against_superman, against_jump_kick, against_low_punch, against_low_kick, against_duck_guard, #0xCCCC, #0xCCCC, #0xCCCC, #0xCCCC
;;=============================================================================================================
;; AI System Public Functions
;;
;; Initializes the AI system
;;
sys_ai_init::
	;push hl
	ld (_ptr_to_player), de
	;ld  hl, #sizeof_e
	;add	hl, de
	;ld (_ptr_to_enemy), hl	;;Aqui guarda la direccion de memoria al puntero de entidades
	;pop hl

	;ld a,	r			;;Pillo el valor de R para "generar" un numero aleatorio entre 0 - 127

	inc hl
	ld 	a,	(hl)
	dec a
	jp	z,	Easy
	dec a
	jp	z,	Medium
Hard:
	ld	a,	#63						;;Hace que tenga un 50% de probabilidades de saber que hara el jugador
	ld (porcentaje_resta),	a
	ld 	a,	#0x0F
	ld (time_thinking),	a
	ld (time),	a
	jp	endif
Medium:
	ld	a,	#31						;;Hace que tenga un 25% de probabilidades de saber que hara el jugador
	ld (porcentaje_resta),	a
	ld 	a,	#0x1F
	ld (time_thinking),	a
	ld (time),	a
	jp	endif
Easy:
	ld	a,	#15						;;Hace que tenga un 12,5% de probabilidadesde saber que hara el jugador
	ld (porcentaje_resta),	a
	ld 	a,	#0x3F
	ld (time_thinking),	a
	ld (time),	a
endif:

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_PHYSICS::Update
;; Updates all AI components of entities
;; Assunes that exist at least one entity in the array 
;; and also assumes that the entities are correct.
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, IX
;; STACK USE: 2 bytes
;;
sys_ai_update::

;_ptr_to_enemy = . + 2
	
_ptr_to_player = . + 2				;;Aqu se carga la direccion de memoria al puntero de entidades
	ld	ix, #0x0000

_decision_making:

_close_enough:

	ld a,	(planning)			;;Aqui vemos si esta realizando alguna accion complicada ej. duck_guard, superman...
	cp #0
	jp z,	_see_distance	;;Si no estaba realizando ya una accion lo mandamos a calcular una

	dec a
	jp z,	_duck_guard2	;;Si no estaba realizando ya una accion lo mandamos a calcular una	

	dec a
	jp z,	_jump_kick2	;;Si no estaba realizando ya una accion lo mandamos a calcular una	

	dec a
	jp z,	_superman2	;;Si no estaba realizando ya una accion lo mandamos a calcular una	

	dec a
	jp z,	_low_kick2	;;Si no estaba realizando ya una accion lo mandamos a calcular una	

	dec a
	jp z,	_low_punch2	;;Si no estaba realizando ya una accion lo mandamos a calcular una

	jp	_see_distance

_see_distance:

	ld	a,	f_action(ix)		;;Si ya esta haciendo un movimiento no hacer nada
	cp 	#stance
	jp	nz,	_thinking

	ld	 a,	(time_thinking)

	cp 	#0
	jp	z,	_fighting	;;Esto mira un temporizador para que la IA piense
	dec a
	ld	(time_thinking),	a	


	ld	a,	e_nxtaction(ix)
	cp	#0
	jp	z,	_thinking	;;Esto mira un temporizador para que la IA piense

_fighting:

	ld	a, 	e_x(ix)
	add #tamano_estandar		;;Ya que miramos el tamano de la posicion stance del jugador
	sub f_x(ix)
	jp 	z, _calculate_action			;;Comprueba si esta pegado al jugador

I_cant_beat_you_without_getting_closer:

	ld	f_nxtaction(ix),	#moving
	ld 	a,	#0
	ld 	(planning),	a					;;Esto lo hago por si recibe un golpe o por si el otro se mueve para resetear lo que va a hacer
	ret

_calculate_action:

	ld 	a,	r			;;Pillo el valor de R para "generar" un numero aleatorio entre 0 - 127
	ld	l,	a

porcentaje_resta = . + 1
	sub	#00				;;Aqui primero miramos si sabe lo que va a hacer el jugador, dificultad: facil-10%, media-25%, dificil-50%
	jp nc, _random_action

	ld 	a, 	e_nxtaction(ix)
	add a
	ld 	iy, #switch
	ld 	c,	a
	ld 	b,	#0
	add iy,	bc
	ld 	h,	1(iy)
	ld 	l,	(iy)
	jp 	(hl)

against_guard:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127			

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _kick

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_punch

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_kick

	ret					;;Este ret es la accion stance, con lo cual no hace nada el personaje

against_duck:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127						;;Deja el numero aleatorio entre 0 - 127			

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _kick

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_punch

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_kick

	jp _duck_guard

against_jump:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127						;;Deja el numero aleatorio entre 0 - 127			

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _guard

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _punch

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_kick

	jp _duck_guard

against_punch:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127						;;Deja el numero aleatorio entre 0 - 127			

	sub #95				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _guard

	ret

against_kick:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127							;;Deja el numero aleatorio entre 0 - 127			

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _duck_guard

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _superman

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _jump_kick

	ret

against_superman:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127						;;Deja el numero aleatorio entre 0 - 127			

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _guard

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_punch

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_kick

	jp _duck_guard

against_jump_kick:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _guard

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_punch

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_kick

	jp _duck_guard

against_low_punch:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127			

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _duck_guard

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _superman

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _jump_kick

	ret

against_low_kick:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127			

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _duck_guard

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _superman

	sub #31				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _jump_kick

	ret

against_duck_guard:

	call sys_random_num						;;Deja el numero aleatorio entre 0 - 127			

	sub #95				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _punch

	ret


_random_action:

	call sys_random_num	;;Devuelve un numero aleatorio entre 0 - 127			

	sub #16				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _guard

	sub #16				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _punch

	sub #16				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _kick

	sub #16				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_punch

	sub #16				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _low_kick

	sub #16				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _superman

	sub #16				;;Restamos 16 porque tengo 8 acciones posibles que hacer y el numero aleatorio sera entre 0-127
	jp c, _jump_kick

_duck_guard:

	ld	f_nxtaction(ix),	#duck
	ld	a,	#1
	ld (planning),	a
	ret

_duck_guard2:

	ld	f_nxtaction(ix),	#duck_guard
	ld	f_actcd(ix),	#0
	xor	a
	ld 	(planning),	a

	call	sys_ai_timing

	ret

_jump_kick:

	ld	f_nxtaction(ix),	#jump
	ld	f_vy(ix),	#-5
	ld	a,	#2
	ld (planning),	a
	ret

_jump_kick2:

	ld	f_nxtaction(ix),	#jump_kick
	ld	f_actcd(ix),	#0
	xor	a
	ld 	(planning),	a

	call	sys_ai_timing

	ret

_superman:

	ld	f_nxtaction(ix),	#jump
	ld	f_vy(ix),	#_VSalto
	ld	a,	#3
	ld (planning),	a
	ret

_superman2:

	ld	f_nxtaction(ix),	#superman
	ld	f_actcd(ix),	#0
	xor	a
	ld 	(planning),	a

	call	sys_ai_timing

	ret

_low_kick:

	ld	f_nxtaction(ix),	#duck
	ld	a,	#4
	ld (planning),	a
	ret

_low_kick2:

	ld	f_nxtaction(ix),	#low_kick
	ld	f_actcd(ix),	#0
	xor	a
	ld 	(planning),	a

	call	sys_ai_timing

	ret

_low_punch:

	ld	f_nxtaction(ix),	#duck
	ld	a,	#5
	ld (planning),	a
	ret

_low_punch2:

	ld	f_nxtaction(ix),	#low_punch
	ld	f_actcd(ix),	#0
	xor	a
	ld 	(planning),	a

	call	sys_ai_timing

	ret

_kick:

	ld	f_nxtaction(ix),	#kick

	call	sys_ai_timing

	ret

_punch:

	ld	f_nxtaction(ix),	#punch
	call	sys_ai_timing

	ret

_guard:

	ld	f_nxtaction(ix),	#guard
	call	sys_ai_timing

	ret

_thinking:

	;ld	a, 	f_action(ix)
	;cp	#stance
	;call z, sys_ai_stance
	cp	#moving
	call z, sys_ai_moving

	ret

sys_random_num:
	call cpct_getRandom_lcg_u8_asm	;;Calcula un numero aleatorio entre -128 - 127 usando l para mezclar la seed
	ld	a,	#0x7F
	and	l	
	ret

;;ESTAS DOS FUNCIONES DE ABAJO PASARLAS A SYS_ACTION
;;EN ESTE SISTEMA SOLO TOMAR LA DECISION A TOMAR A CONTINUACION
;;De momento cambia de stance a moving y viceversa

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_PHYSICS::Update
;; Updates all AI components of entities
;; Assunes that exist at least one entity in the array 
;; and also assumes that the entities are correct.
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, IX
;; STACK USE: 2 bytes
;;
;sys_ai_stance::
;	ld 	a,	e_ai_aim_x(ix)
;	or 	a
;	ret z
;
;	ld	e_action(ix), #moving
;	ld	e_nxtaction(ix), #stance
;	ret

sys_ai_timing::
	;call sys_random_num	;;Devuelve un numero aleatorio entre 0 - 127
time = . + 1
	ld	a, #0
	ld (time_thinking),	a
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_PHYSICS::Update
;; Updates all AI components of entities
;; Assunes that exist at least one entity in the array 
;; and also assumes that the entities are correct.
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, IX
;; STACK USE: 2 bytes
;;
sys_ai_moving::

	;ld	f_actcd(ix),	#0xFF	;;Esto es para que se mueva hasta que yo le diga

	ld	a, e_x(ix)
	add #tamano_estandar
	sub f_x(ix)
	jp 	nc, _greater_or_equal

_lesser:

	ld	f_vx(ix), #-1
	jp	_endif_x

_greater_or_equal:

	jp	z,	_arrived
	ld	f_vx(ix), #1
	jp	_endif_x

_arrived:

	ld	f_vx(ix),			#0
	ld	f_actcd(ix),		#0
	ld	f_nxtaction(ix),	#0

_endif_x:

	ret
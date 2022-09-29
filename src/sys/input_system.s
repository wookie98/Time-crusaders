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
;;	INPUT SYSTEM
;;

   .include "cpctelera.h.s"
   .include "cpct_functions.h.s"
   .include "cmp/entity.h.s"
   .include "sys/sprite_system.h.s"

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_INPUT::Init
;;
;; Initializes Input System
;;
sys_input_init::
	ld (_ptr_to_entities), de	;;Aqui guarda la direccion de memoria al puntero de entidades
								;;No estamos guardando a porque de momento no lo necesitamos
	;inc hl
	ld 	a,	(hl)
	dec a
	jr	nz,	PlayerVsPlayer
PlayerVsIA:
	ld	de,	#sys_input_player
	ld (_to_jump),	de
	jr	endif3
PlayerVsPlayer:
	ld	de,	#sys_input_player2
	ld (_to_jump),	de
endif3:
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_INPUT::Init
;;
;; Initializes Input System
;;
sys_input_menu::
	ld	(position1), hl
	ld	(position2), hl
	ld	(position3), hl

	;;Scan the Keyboard
	call cpct_scanKeyboard_f_asm

	ld		hl, #Key_C
	call 	cpct_isKeyPressed_asm
	jr		z, C_NotPressed_menu	;;Comprueba si el jugador esta pulsando la Q

C_Pressed_menu:

	position1 = .+1
	ld	hl, #0x0000
	ld 	a, (hl)
	dec a
	jr 	z, startGame				;;Comprueba si esta en la primera opcion
	dec a
	jr 	z, changeDifficulty			;;Comprueba si esta en la segunda opcion

changePlayer:

		inc hl
		inc hl
		ld 	a, (hl)
		dec a
		jr	z,	vsPlayer				;;Comprueba contra quien juega ahora mismo

	vsIA:

		ld (hl), #1						;;Juegas contra la IA
		jr	C_NotPressed_menu

	vsPlayer:

		ld (hl), #2						;;Juegas contra player 2
		jr	C_NotPressed_menu

changeDifficulty:	

		inc hl
		ld 	a, (hl)
		dec a
		jr	z,	Medium				;;Comprueba contra quien juega ahora mismo
		dec a
		jr 	z, 	Hard

	Easy:

		ld (hl), #1						;;Pone el modo en facil
		jr	C_NotPressed_menu

	Medium:

		ld (hl), #2						;;Pone el modo en medio
		jr	C_NotPressed_menu

	Hard:

		ld (hl), #3						;;Pone el modo en dificil
		jr	C_NotPressed_menu			

startGame:

	ld (hl), #4						;;Hara empezar el juego

C_NotPressed_menu:

	ld		hl, #Key_Q
	call 	cpct_isKeyPressed_asm
	jr		z, Q_NotPressed_menu			;;Comprueba si el jugador esta pulsando la Q

Q_Pressed_menu:

	position2 = .+1
	ld	hl, #0x0000
	ld 	a, (hl)
	dec a
	jr 	z, Q_NotPressed_menu			;;Comprueba si esta en la primera opcion

goUp:				

	dec (hl)

Q_NotPressed_menu:

	ld		hl, #Key_A
	call 	cpct_isKeyPressed_asm
	jr		z, A_NotPressed_menu			;;Comprueba si el jugador esta pulsando la Q

A_Pressed_menu:

	position3 = .+1
	ld	hl, #0x0000
	ld 	a, (hl)
	sub a, #3
	jr 	z, A_NotPressed_menu			;;Comprueba si esta en la primera opcion

goDown:				

	inc (hl)

A_NotPressed_menu:

	ret


;;De momento movemos el personaje con O a izquierda,
;; P a derecha y A para saltar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_INPUT::Update
;; Gets Keyboard inputs and applies them to Keyboard
;; controlled entities.
;; Assumes entity 0 always exists
;; INPUT: 
;;		IX = Pointer to entity[0]
;; DESTROYS: AF, BC, DE, HL, IX?
;;
sys_input_update::

	_ptr_to_entities = . + 2
	ld 	ix, #0x0000					;;Aquí se carga la direccion de memoria al puntero de entidades

	;;Scan the Keyboard
	call cpct_scanKeyboard_f_asm

	_to_jump = . + 1
	call	#0x0000
	ret

;;De momento movemos el personaje con O a izquierda,
;; P a derecha y A para saltar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_INPUT::Update
;; Gets Keyboard inputs and applies them to Keyboard
;; controlled entities.
;; Assumes entity 0 always exists
;; INPUT: 
;;		IX = Pointer to entity[0]
;; DESTROYS: AF, BC, DE, HL, IX?
;;
sys_input_player2:

	;;ld 	f_vx(ix), #0
ld 	a,f_action(ix)
	cp 	#stance
	jr z,f_move
	cp #jump
	jr z,f_move
	cp #duck
	jr z,K_NotPressed
	cp #jump_kick
	jr z,f_move	
	cp #superman
	jr z,f_move
	
	jr f_no_se_porque_me_da_error_sin_esto
f_move:
	;;Check for movement keys
	ld		hl, #Key_O				;;Movimiento eje x
	call 	cpct_isKeyPressed_asm
	jr		z, H_NotPressed			
H_Pressed:
	ld		f_vx(ix), #-1
H_NotPressed:

	ld		hl, #Key_P
	call 	cpct_isKeyPressed_asm
	jr		z, K_NotPressed
K_Pressed:
	ld		f_vx(ix), #1
K_NotPressed:

	ld		hl, #Key_N				;;Movimiento eje y
	call 	cpct_isKeyPressed_asm
	jr		z, J_NotPressed
J_Pressed:
	ld 	a, 	f_action(ix)
	cp #jump
	jr	z, 	J_NotPressed			;;Comprueba si ya esta saltando
	cp #jump_kick
	jr	z, 	J_NotPressed			;;Comprueba si ya esta saltando
	cp #superman
	jr	z, 	J_NotPressed			;;Comprueba si ya esta saltando
f_do_duck:
	ld 		f_nxtaction(ix), #duck
	ld 		f_actcd(ix),#0

J_NotPressed:



	ld		hl, #Key_B				;;Golpe jugador
	call 	cpct_isKeyPressed_asm
	jr		z, f_O_NotPressed
f_O_Pressed:
	ld 		a,	f_action(ix)
	cp      #0						;;No se que hace esto exactamente pero lo voy a dejar porque lo has puesto
	jr      z,f_punch
	cp 		#jump
	jr      z,f_superman
	cp 		#duck
	jr      z,f_low_punch
	jr f_O_NotPressed
f_punch:
	ld		f_nxtaction(ix), #punch
	jr f_O_NotPressed
f_superman:
	ld	f_nxtaction(ix), #superman
	ld f_actcd(ix),#0
	jr f_O_NotPressed
f_low_punch:
	ld	f_nxtaction(ix), #low_punch
	ld f_actcd(ix),#0
	jr f_O_NotPressed
f_no_se_porque_me_da_error_sin_esto:
jr U_NotPressed

f_O_NotPressed:
	ld		hl, #Key_V				;;Golpe jugador
	call 	cpct_isKeyPressed_asm
	jr		z, f_P_NotPressed
f_P_Pressed:
	ld 		a,	f_action(ix)
	cp      #0						;;No se que hace esto exactamente pero lo voy a dejar porque lo has puesto
	jr      z,f_kick
	cp 		#jump
	jr      z,f_jump_kick
	cp 		#duck
	jr      z,f_low_kick
	jr f_P_NotPressed
f_kick:
	ld		f_nxtaction(ix), #kick
	jr f_P_NotPressed
f_jump_kick:
	ld	f_nxtaction(ix), #jump_kick
	ld f_actcd(ix),#0
	jr f_P_NotPressed
f_low_kick:
	ld f_nxtaction(ix), #low_kick
	ld f_actcd(ix),#0
	jr f_P_NotPressed
f_P_NotPressed:
		;;Check for movement keys
	ld		hl, #Key_C				;;Movimiento eje x
	call 	cpct_isKeyPressed_asm
	jr		z, L_NotPressed			
L_Pressed:
	ld		a,f_action(ix)
	cp      #duck
	jr nz,f_No_duck_guard
	cp #duck_guard
	jr z,L_NotPressed
f_Do_duck_guard:
	ld 	f_nxtaction(ix),#duck_guard
	ld f_actcd(ix),#0
	jr L_NotPressed
f_No_duck_guard:
	ld		f_nxtaction(ix), #guard
L_NotPressed:


	ld		hl, #Key_M				;;Movimiento eje y
	call 	cpct_isKeyPressed_asm
	jr		z, U_NotPressed
U_Pressed:
	ld 	a, 	f_action(ix)
	cp #jump
	jr	z, 	U_NotPressed			;;Comprueba si ya esta saltando
	cp #superman
	jr	z, 	U_NotPressed			;;Comprueba si ya esta saltando
	cp #jump_kick
	jr	z, 	U_NotPressed			;;Comprueba si ya esta saltando
f_do_jump:
	ld		f_vy(ix), #_VSalto
	ld 		f_nxtaction(ix), #jump
	ld 		f_actcd(ix),#0
U_NotPressed:
	
	;;ld 	e_vx(ix), #0
	;ld 	f_vx(ix), #0

	;checks if the player is doing an action that blocks it's movement
	ld 	a,e_action(ix)
	cp 	#stance
	jr z,	move2
	cp #jump
	jr z,	move2
	cp #duck
	jr z,G_NotPressed
	cp #jump_kick
	jr z,	move2
	cp #superman
	jr z,	move2
	
	ret
move2:
	
	;;Check for movement keys
	ld		hl, #Key_T				;;Movimiento eje x
	call 	cpct_isKeyPressed_asm
	jr		z, F_NotPressed		
F_Pressed:
	ld		e_vx(ix), #-1
F_NotPressed:

	ld		hl, #Key_Y
	call 	cpct_isKeyPressed_asm
	jr		z, G_NotPressed
G_Pressed:
	ld		e_vx(ix), #1
G_NotPressed:

ld		hl, #Key_F
	call 	cpct_isKeyPressed_asm
	jr		z, Z_NotPressed2
Z_Pressed2:
	ld 	a, 	e_action(ix)
	cp #jump
	jr	z, 	Z_NotPressed2			;;Comprueba si ya esta saltando
	cp #jump_kick
	jr	z, 	Z_NotPressed2			;;Comprueba si ya esta saltando
	cp #superman
	jr	z, 	Z_NotPressed2			;;Comprueba si ya esta saltando
do_duck2:
	ld 		e_nxtaction(ix), #duck
	ld 		e_actcd(ix),#0

Z_NotPressed2:

	ld		hl, #Key_D				;;Punch
	call 	cpct_isKeyPressed_asm
	jr		z, Q_NotPressed2
Q_Pressed2:
	ld 		a,	e_action(ix)
	cp      #0						;;No se que hace esto exactamente pero lo voy a dejar porque lo has puesto
	jr      z,_punch2
	cp 		#jump
	jr      z,_superman2
	cp 		#duck
	jr      z,_low_punch2
	jr Q_NotPressed2
_punch2:
	ld		e_nxtaction(ix), #punch
	jr Q_NotPressed2
_superman2:
	ld	e_nxtaction(ix), #superman
	ld e_actcd(ix),#0
	jr Q_NotPressed2
_low_punch2:
	ld	e_nxtaction(ix), #low_punch
	ld e_actcd(ix),#0
	jr Q_NotPressed2
Q_NotPressed2:

	ld		hl, #Key_S				;;Kick
	call 	cpct_isKeyPressed_asm
	jr		z, W_NotPressed2
W_Pressed2:
	ld 		a,	e_action(ix)
	cp      #0						;;No se que hace esto exactamente pero lo voy a dejar porque lo has puesto
	jr      z,_kick2
	cp 		#jump
	jr      z,_jump_kick2
	cp 		#duck
	jr      z,_low_kick2
	jr W_NotPressed2
_kick2:
	ld		e_nxtaction(ix), #kick
	jr W_NotPressed2
_jump_kick2:
	ld	e_nxtaction(ix), #jump_kick
	ld e_actcd(ix),#0
	jr W_NotPressed2
_low_kick2:
	ld	e_nxtaction(ix), #low_kick
	ld e_actcd(ix),#0
	jr W_NotPressed2
W_NotPressed2:
		;;Check for movement keys
	ld		hl, #Key_A				;;Movimiento eje x
	call 	cpct_isKeyPressed_asm
	jr		z, X_NotPressed2		
X_Pressed2:
	ld		a,e_action(ix)
	cp      #duck
	jr nz,No_duck_guard2
	cp #duck_guard
	jr z,X_NotPressed2
Do_duck_guard2:
	ld 	e_nxtaction(ix),#duck_guard
	ld e_actcd(ix),#0
	jr X_NotPressed2
No_duck_guard2:
	ld		e_nxtaction(ix), #guard
X_NotPressed2:


	ld		hl, #Key_G				;;Movimiento eje y
	call 	cpct_isKeyPressed_asm
	jr		z, A_NotPressed2
A_Pressed2:
	ld 	a, 	e_action(ix)
	cp #jump
	jr	z, 	A_NotPressed2			;;Comprueba si ya esta saltando
	cp #superman
	jr	z, 	A_NotPressed2			;;Comprueba si ya esta saltando
	cp #jump_kick
	jr	z, 	A_NotPressed2			;;Comprueba si ya esta saltando
do_jump2:
	ld		e_vy(ix), #_VSalto
	ld 		e_nxtaction(ix), #jump
	ld 		e_actcd(ix),#0
A_NotPressed2:

	ret

;;De momento movemos el personaje con O a izquierda,
;; P a derecha y A para saltar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_INPUT::Update
;; Gets Keyboard inputs and applies them to Keyboard
;; controlled entities.
;; Assumes entity 0 always exists
;; INPUT: 
;;		IX = Pointer to entity[0]
;; DESTROYS: AF, BC, DE, HL, IX?
;;
sys_input_player:

	;;Reset velocities
	ld 	e_vx(ix), #0
	ld 	f_vx(ix), #0

	;checks if the player is doing an action that blocks it's movement
	ld 	a,e_action(ix)
	cp 	#stance
	jr z,	move
	cp #jump
	jr z,	move
	cp #duck
	jr z,P_NotPressed
	cp #jump_kick
	jr z,	move
	cp #superman
	jr z,	move
	
	ret
move:
	
	;;Check for movement keys
	ld		hl, #Key_O				;;Movimiento eje x
	call 	cpct_isKeyPressed_asm
	jr		z, O_NotPressed			
O_Pressed:
	ld		e_vx(ix), #-1
O_NotPressed:

	ld		hl, #Key_P
	call 	cpct_isKeyPressed_asm
	jr		z, P_NotPressed
P_Pressed:
	ld		e_vx(ix), #1
P_NotPressed:

ld		hl, #Key_R				;;Agacharse
	call 	cpct_isKeyPressed_asm
	jr		z, Z_NotPressed
Z_Pressed:
	ld 	a, 	e_action(ix)
	cp #jump
	jr	z, 	Z_NotPressed			;;Comprueba si ya esta saltando
	cp #jump_kick
	jr	z, 	Z_NotPressed			;;Comprueba si ya esta saltando
	cp #superman
	jr	z, 	Z_NotPressed			;;Comprueba si ya esta saltando
do_duck:
	ld 		e_nxtaction(ix), #duck
	ld 		e_actcd(ix),#0

Z_NotPressed:

	ld		hl, #Key_E				;;Punch
	call 	cpct_isKeyPressed_asm
	jr		z, Q_NotPressed
Q_Pressed:
	ld 		a,	e_action(ix)
	cp      #0						;;No se que hace esto exactamente pero lo voy a dejar porque lo has puesto
	jr      z,_punch
	cp 		#jump
	jr      z,_superman
	cp 		#duck
	jr      z,_low_punch
	jr Q_NotPressed
_punch:
	ld		e_nxtaction(ix), #punch
	jr Q_NotPressed
_superman:
	ld	e_nxtaction(ix), #superman
	ld e_actcd(ix),#0
	jr Q_NotPressed
_low_punch:
	ld	e_nxtaction(ix), #low_punch
	ld e_actcd(ix),#0
	jr Q_NotPressed
Q_NotPressed:

	ld		hl, #Key_W				;;Patada
	call 	cpct_isKeyPressed_asm
	jr		z, W_NotPressed
W_Pressed:
	ld 		a,	e_action(ix)
	cp      #0						;;No se que hace esto exactamente pero lo voy a dejar porque lo has puesto
	jr      z,_kick
	cp 		#jump
	jr      z,_jump_kick
	cp 		#duck
	jr      z,_low_kick
	jr W_NotPressed
_kick:
	ld		e_nxtaction(ix), #kick
	jr W_NotPressed
_jump_kick:
	ld	e_nxtaction(ix), #jump_kick
	ld e_actcd(ix),#0
	jr W_NotPressed
_low_kick:
	ld	e_nxtaction(ix), #low_kick
	ld e_actcd(ix),#0
	jr W_NotPressed
W_NotPressed:
		;;Check for movement keys
	ld		hl, #Key_Q				;;Movimiento eje x
	call 	cpct_isKeyPressed_asm
	jr		z, X_NotPressed			
X_Pressed:
	ld		a,e_action(ix)
	cp      #duck
	jr nz,No_duck_guard
	cp #duck_guard
	jr z,X_NotPressed
Do_duck_guard:
	ld 	e_nxtaction(ix),#duck_guard
	ld e_actcd(ix),#0
	jr X_NotPressed
No_duck_guard:
	ld		e_nxtaction(ix), #guard
X_NotPressed:


	ld		hl, #Key_T				;;Salto
	call 	cpct_isKeyPressed_asm
	jr		z, A_NotPressed
A_Pressed:
	ld 	a, 	e_action(ix)
	cp #jump
	jr	z, 	A_NotPressed			;;Comprueba si ya esta saltando
	cp #superman
	jr	z, 	A_NotPressed			;;Comprueba si ya esta saltando
	cp #jump_kick
	jr	z, 	A_NotPressed			;;Comprueba si ya esta saltando
do_jump:
	ld		e_vy(ix), #_VSalto
	ld 		e_nxtaction(ix), #jump
	ld 		e_actcd(ix),#0
A_NotPressed:
	
	ret
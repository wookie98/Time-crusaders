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
   ;; Include all CPCtelera constant definitions, macros and variables
   .include "cpctelera.h.s"
   .include "cpct_functions.h.s"
   .include "man/game.h.s"
   .include "cmp/entity.h.s"
   .include "man/entity_manager.h.s"
   .area _DATA
   .area _CODE

;;   
;;uncontador: .db 06
;;int_handler::;;;las interrupciones se hacen en cualquier momento, esto puede causar errores insperados
;;;ex af',af
;;;exx
;;   push af
;;   push bc
;;   push de
;;   push hl
;;   ld a,(uncontador)
;;   dec a
;;   jr nz, _cont
;;   _zero:
;;   ;cpctm_setBorder_asm HW_BRIGHT_WHITE
;;   ;_guard:
;;   ;scf
;;   call cpct_akp_musicPlay_asm;call c, cpct_akp_musicPlay_asm
;;   ;call cpct_scanKeyboard_if_asm
;;   ld a,#6
;;   _cont:
;;   ld (uncontador),a
;;   ld h,a
;;   ld l,#16
;;   call cpct_setPalColour_asm
;;;ex af',af
;;;exx
;;   push hl
;;   push de
;;   push bc
;;   push af
;;   ei
;;reti
;;
;;set_init_handler: 
;;call cpct_waitVSYNC_asm
;;halt
;;halt
;;call cpct_waitVSYNC_asm 
;;   ld hl,#0x38
;;   ld (hl),#0xC3
;;   inc hl
;;   ld (hl),#<int_handler
;;   inc hl
;;   ld (hl),#>int_handler
;;   inc hl
;;   ld (hl),#0xC9
;;   ret

   ;;
   ;; MAIN function. This is the entry point of the application.
   ;;    _main:: global symbol is required for correctly compiling and linking
   ;;

_main::
   ;; Disable firmware to prevent it from interfering with string drawing
   start::
   call cpct_disableFirmware_asm;si uso ek int_handler tengo que comentar esto
   ;; Init game manager
   call man_game_init
   ;ld de,#_song_menu
   ;call cpct_akp_musicInit_asm
   ;
   ;_menu loop:
   ;call cpct_waitVSYNC_asm
   ;;;;;;;call cpct_akp_musicPlay_asm;;
   ;call man_menu_update
   ;;halt
   ;;halt
   ;jr z,menu_loop
   ;call man_game_init
   ;;call cpct_akp_musicPlay_asm
   ;;cpctm_setBorder_asm HW_WHITE
 ;Loop forever
loop:
  	 call man_game_update
   ;waitNVSyncs 2
   	call cpct_waitVSYNC_asm
   	call man_game_render
   	call man_entity_getArray
   
	ld__ixh_d
	ld__ixl_e
   	ld a, e_action(ix)
   	cp #KO
	jp z,	defeat_animation
	ld a, e_action(ix)
   	cp #winner
   	jp z,	victory_animation
jp loop
;
;   call_defeat_animation:
;   call defeat_animation
;   jr start
;
;   call_victory_animation:
;   call victory_animation
;   jr start

victory_animation::

	call man_entity_winner
	
	ld hl, #0x000D
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido

	;; Calculate new Video Memory Pointer
	ld		de, #0xC000
	ld		 c, #20					;;Byte axis x		
	ld		 b, #95					;;Pixel axis y
	call	cpct_getScreenPtr_asm

	call cpct_drawStringM0_asm		;;Esta funcion destruye los registros del puntero y la referencia a memoria del String pero por suerte
									;;los deja para continuar escribiendo seguido entonces al hacer un inc iy cojo la siguiente palabra

	ld hl, #0x0001
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido

	ld	a,	#0x1F

_loop_win:
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	dec	a
	jp	nz,	_loop_win
	jp	start



defeat_animation::

	call man_entity_loser
	
	ld hl, #0x0003
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido

	;; Calculate new Video Memory Pointer
	ld		de, #0xC000
	ld		 c, #20					;;Byte axis x		
	ld		 b, #95					;;Pixel axis y
	call	cpct_getScreenPtr_asm

	call cpct_drawStringM0_asm		;;Esta funcion destruye los registros del puntero y la referencia a memoria del String pero por suerte
									;;los deja para continuar escribiendo seguido entonces al hacer un inc iy cojo la siguiente palabra

	ld hl, #0x0001
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido

	ld	a,	#0x1F

_loop_lose:
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	halt
	dec	a
	jp	nz,	_loop_lose
	jp	start

   

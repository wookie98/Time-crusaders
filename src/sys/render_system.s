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
;;	RENDER SYSTEM
;;

.include "cpct_functions.h.s"
.include "man/entity_manager.h.s"
.include "cpctelera.h.s"
.include "cmp/entity.h.s"
;.include "assets/assets.h.s"
.include "sys/sprite_system.h.s"
.include "sys/render_system.h.s"

;;=============================================================
;; Render System Constants
screen_start	= 0xC000
anchura_barra_vida = 32
;.globl _sprite_stance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER::Init
;; Inits the render system
;; DESTROYS: AF, BC, DE, HL
;;
.globl _palette
sys_render_init::

	ld (_ptr_to_entities), de	;;Aqui guarda la direccion de memoria a las entidades
	ld (_ptr_to_entities2), de	;;Aqui guarda la direccion de memoria a las entidades
	ld (_ptr_to_entities3), de	;;Aqui guarda la direccion de memoria a las entidades
	ld (_num_entities), bc		;;Aqui guarda la direccion de memoria al numero de entidades
	ld (_ptr_to_string), hl		;;Aqui guarda la direccion de memoria del string Player 1...

	ld 	a,	#8					;;Cargo 8 porque el tamano de la palabra P1 es 8
	add	#anchura_barra_vida	

	ld (comienzo_P2),	a
	
	ld		c, #0
	call 	cpct_setVideoMode_asm
	ld		hl, #_palette ;;Hay que arreglar, probablemente los assets
	ld		de, #16
	call	cpct_setPalette_asm
	;cpctm_setBorder_asm
	;ld hl,#_fondo_BAD
	;ld de, #0xC000
	;ld bc,#0x4000
	;ldir
	 
	ret
sys_render_fondo::
ld hl,#_fondo
ld de, #0xC000
ld bc,#0x4000
ldir
;;ld hl,#_fondo2
;;ld de, #0xF200
;;ld bc,#0x0CFF
;;ldir
ld		de, #0xC550;;136
ld		a,#0xC3;;FC lila C0 axul claro 33 verde 00 negro 03 blanco CC rojo 0C axul cielo fondo 3C otro azul C3 verde marron
ld	 b, #64
ld 	c,#64
call 	cpct_drawSolidBox_asm
ld		de, #0xC590
ld		a,#0xC3;;FC lila C0 axul claro 33 verde 00 negro 03 blanco CC rojo 0C axul cielo fondo 3C otro azul C3 verde marron
ld	 b, #64
ld 	c,#16
call 	cpct_drawSolidBox_asm

		;
	;call cpct_drawSpriteBlended_asm
	;push 	bc
	;ld	a,(_ent_counter)
	;cp #1
	;jr z,draw_square
	;ld a,e_change(ix)
	;cp #1
	;jr nz,mem_ptr
	;draw_square:
	;ld		a,#0xC0
	


ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER::Menu
;; Shows the menu
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, HL, IX
;; STACK USE: 2 bytes
;;
sys_render_menu::
	ld	(position1), hl
	ld	(position2), hl
	ld	(position3), hl
	inc	hl
	ld	(position4), hl
	inc	hl
	ld	(position5), hl
	ld	(position6), hl

	ld hl, #0x0003
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido

	;; Calculate new Video Memory Pointer
	ld		de, #screen_start
	ld		 c, #4					;;Byte axis x		
	ld		 b, #0					;;Pixel axis y
	call	cpct_getScreenPtr_asm

	call cpct_drawStringM0_asm		;;Esta funcion destruye los registros del puntero y la referencia a memoria del String pero por suerte
									;;los deja para continuar escribiendo seguido entonces al hacer un inc iy cojo la siguiente palabra
	inc iy
	call cpct_drawStringM0_asm

	ld hl, #0x0001
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido



	position1 = .+1
	ld	a, (#0x0000)
	dec a
	jr nz, not_selected1			;;Comprueba si el jugador esta en esta opcion

selected1:				

	ld hl, #0x000D
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido

	call sys_render_menu1

	ld hl, #0x0001
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en amarillo

	jr endif1

not_selected1:

	call sys_render_menu1

endif1:

	position2 = .+1
	ld	a, (#0x0000)
	sub #2
	jr nz, not_selected2			;;Comprueba si el jugador esta en esta opcion

selected2:

	ld hl, #0x000D
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido

	call sys_render_menu2

	ld hl, #0x0001
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en amarillo

	jr endif2

not_selected2:

	call sys_render_menu2

endif2:

	position3 = .+1
	ld	a, (#0x0000)
	sub #3
	jr nz, not_selected3			;;Comprueba si el jugador esta en esta opcion

selected3:

	ld hl, #0x000D
	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en verde palido

	call 	sys_render_menu3
	ld hl, #0x0001

	call cpct_setDrawCharM0_asm		;;Pinta el fondo a azul oscuro y la frase en amarillo
	jr endif3

not_selected3:

	call 	sys_render_menu3

endif3:

	position6 = .+1
	ld	a, (#0x0000)
	dec a
	jr nz, nothingToDo				;;Mira si esta luchando con la IA o un jugador

jump_one_word:

	ld 	bc, #sizeof_word
	add iy, bc

nothingToDo:

	;;TODO ESTO ULTIMO PONE LAS INTRUCCIONES DE COMO MOVERSE, SI CAMBIAMOS LAS LETRAS CAMBIARLO
	;; Calculate new Video Memory Pointer
	ld		de, #screen_start
	ld		 c, #44 				;;Byte axis x		
	ld		 b, #176			;;Pixel axis y
	call	cpct_getScreenPtr_asm

	inc	iy
	call cpct_drawStringM0_asm		;;Escribe Up: Q

	;; Calculate new Video Memory Pointer
	ld		de, #screen_start
	ld		 c, #44 				;;Byte axis x		
	ld		 b, #184			;;Pixel axis y
	call	cpct_getScreenPtr_asm

	inc	iy
	call cpct_drawStringM0_asm		;;Escribe Down: a

	;; Calculate new Video Memory Pointer
	ld		de, #screen_start
	ld		 c, #44 			;;Byte axis x		
	ld		 b, #192			;;Pixel axis y
	call	cpct_getScreenPtr_asm

	inc	iy
	call cpct_drawStringM0_asm		;;Escribe Select: P

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER::Menu
;; Shows the menu
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, HL, IX
;; STACK USE: 2 bytes
;;
sys_render_menu1::

	;; Calculate new Video Memory Pointer
	ld		de, #screen_start
	ld		 c, #22 				;;Byte axis x		
	ld		 b, #34					;;Pixel axis y
	call	cpct_getScreenPtr_asm

	inc	iy
	call cpct_drawStringM0_asm		;;Esta funcion destruye los registros del puntero y la referencia a memoria del String pero por suerte
									;;los deja para continuar escribiendo seguido entonces al hacer un inc iy cojo la siguiente palabra
									;;Esto habra dibujado New Game

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER::Menu
;; Shows the menu
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, HL, IX
;; STACK USE: 2 bytes
;;
sys_render_menu2::

	;; Calculate new Video Memory Pointer
	ld		de, #screen_start
	ld		 c, #6 					;;Byte axis x		
	ld		 b, #90					;;Pixel axis y
	call	cpct_getScreenPtr_asm

	inc	iy
	call cpct_drawStringM0_asm		

	position4 = .+1
	ld	a, (#0x0000)
	dec a
	jr z, easy					;;Mira si esta en nivel facil
	dec a
	jr z, medium				;;Mira si esta en nivel medio

hard:

	ld 	bc, #sizeof_2words
	add iy, bc

	inc	iy
	call cpct_drawStringM0_asm		;;Escribe Hard

	ret

medium:

	ld 	bc, #sizeof_word
	add iy, bc

	inc iy
	call cpct_drawStringM0_asm		;;Escribe Medium

	ld 	bc, #sizeof_word
	add iy, bc

	ret

easy:

	inc	iy
	call cpct_drawStringM0_asm		;;Escribe Easy

	ld 	bc, #sizeof_2words
	add iy, bc
	
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER::Menu
;; Shows the menu
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, HL, IX
;; STACK USE: 2 bytes
;;
sys_render_menu3::

	;; Calculate new Video Memory Pointer
	ld		de, #screen_start
	ld		 c, #22 			;;Byte axis x		
	ld		 b, #146			;;Pixel axis y
	call	cpct_getScreenPtr_asm	

	position5 = .+1
	ld	a, (#0x0000)
	dec a
	jr z, vs_IA2				;;Mira si esta luchando con la IA o un jugador

vs_Player2:

	ld 	bc, #sizeof_word
	add iy, bc

	inc iy
	call cpct_drawStringM0_asm	;;Escribe 	J1 vs J2

	ret

vs_IA2:

	inc	iy
	call cpct_drawStringM0_asm	;;Escribe 	J1 vs IA

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER::Update
;; Updates the render system
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, HL, IX
;; STACK USE: 2 bytes
;;
;.globl _fondo_BAD
sys_render_update::

_ptr_to_entities = . + 2
	ld 	ix, #0x0000					;;Aqu se carga la direccion de memoria al puntero de entidades

_num_entities = . + 1
	ld	a,	(#0x0000)					;;Aqui se carga la direccion de memoria al numero de entidades

	;;Render Entities
	call sys_render_entities

_ptr_to_string = . + 2
	ld 	iy, #0x0000		

	call sys_render_life
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_ENTITY::Update
;; Draws all Entity Components
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, HL, IX
;; STACK USE: 2 bytes
;;
sys_render_life::

	ld		hl,	#0xC000

	call cpct_drawStringM0_asm		;;Esta funcion destruye los registros del puntero y la referencia a memoria del String pero por suerte
									;;los deja para continuar escribiendo seguido entonces al hacer un inc iy cojo la siguiente palabra
									;;Esto habra dibujado P1

	ld		d, 	h					;;Esto lo hago porque drawString deja en h y l la siguiente posicion de memoria	
	ld		e, 	l
	push	hl
	ld		b,	#8						;;Altura
	ld		c,	#anchura_barra_vida	
	ld 		a,	#0x00
	call 	cpct_drawSolidBox_asm		;;Borra cuadrado de vida

_ptr_to_entities2 = . + 2
	ld 	ix, #0x0000					;;Aqu se carga la direccion de memoria al puntero de entidades

	pop 	de
	ld		b,	#8						;;Altura
	
	ld		a,	e_lp(ix)
	ld 		c,	a
	sub 	#101						;;Pongo 101 porque la vida maxima es 100
	jp		nc,	_dead
	ld		a,	c
	sub 	#25
	jp		c,	_low_life
	sub 	#25
	jp		c,	_medium_life_down
	sub 	#25
	jp		c,	_medium_life_up
__full_life:
	ld 		a,	#0x33
	ld		c,	#anchura_barra_vida		;;Anchura anchuraNormal
	jp 		endif_life
_medium_life_up:
	ld 		a,	#0x0F
	ld		c,	#24						;;Anchura anchuraNormal/4
	jp 		endif_life
_medium_life_down:
	ld 		a,	#0x0F
	ld		c,	#16						;;Anchura anchuraNormal/4
	jp 		endif_life
_low_life:					
	ld 		a,	#0xCC
	ld		c,	#8						;;Anchura anchuraNormal/4
endif_life:

	call 	cpct_drawSolidBox_asm		;;Dibuja cuadrado de vida
	jp 		_not_dead

_dead:
	ld	e_action(ix),	#KO
_not_dead:

comienzo_P2 = . + 1
	ld 		l, #0x00
	ld 		h, #0xC0

	inc 	iy
	call	cpct_drawStringM0_asm		;;Esta funcion destruye los registros del puntero y la referencia a memoria del String pero por suerte
									;;los deja para continuar escribiendo seguido entonces al hacer un inc iy cojo la siguiente palabra
									;;Esto habra dibujado P2

	ld		d, 	h					;;Esto lo hago porque drawString deja en h y l la siguiente posicion de memoria	
	ld		e, 	l
	push	hl
	ld		b,	#8						;;Altura
	ld		c,	#anchura_barra_vida	
	ld 		a,	#0x00
	call 	cpct_drawSolidBox_asm		;;Borra cuadrado de vida

_ptr_to_entities3 = . + 2
	ld 	ix, #0x0000					;;Aqu se carga la direccion de memoria al puntero de entidades

	pop 	de
	ld		b,	#8						;;Altura
	
	ld		a,	f_lp(ix)
	ld 		c,	a
	sub 	#101						;;Pongo 101 porque la vida maxima es 100
	jp		nc,	_dead2
	ld		a,	c
	sub 	#25
	jp		c,	_low_life2
	sub 	#25
	jp		c,	_medium_life_down2
	sub 	#25
	jp		c,	_medium_life_up2

__full_life2:

	ld 		a,	#0x33
	ld		c,	#anchura_barra_vida		;;Anchura anchuraNormal
	jp 		endif_life2

_medium_life_up2:

	ld 		a,	#0x0F
	ld		c,	#24						;;Anchura anchuraNormal/4
	jp 		endif_life2

_medium_life_down2:

	ld 		a,	#0x0F
	ld		c,	#16						;;Anchura anchuraNormal/4
	jp 		endif_life2

_low_life2:	

	ld 		a,	#0xCC
	ld		c,	#8						;;Anchura anchuraNormal/4
	
endif_life2:

	call 	cpct_drawSolidBox_asm		;;Dibuja cuadrado de vida
	jp 		_not_dead2

_dead2:

	ld	e_action(ix),	#winner

_not_dead2:

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_ENTITY::Update
;; Draws all Entity Components
;; INPUT: 
;;		IX = Pointer to the entitiy array
;;		A  = Number of elements in the array
;; DESTROYS: AF, BC, DE, HL, IX
;; STACK USE: 2 bytes
;;
sys_render_entities::

	ld	(_ent_counter), a

_update_loop:
	;;Erase Previous Instance (Draw Background Pixels)
	;ld a,e_actcd(ix)
	;sub #1
	;jr c,mem_ptr

	ld		e, e_lastVP_l(ix)
	ld		d, e_lastVP_h(ix)
	ld		a,#0xC3;;FC lila C0 axul claro 33 verde 00 negro 03 blanco CC rojo 0C axul cielo fondo 3C otro azul C3 verde marron
	;ld	 l, e_sprite_l(ix)
	;ld	 h, e_sprite_h(ix)
	;ld	 b, #31;;not blended
	;ld 	c, e_w(ix)
	ld	 b, #31
	ld 	c,e_lastW(ix)
	;
	;call cpct_drawSpriteBlended_asm
	;push 	bc
	;ld	a,(_ent_counter)
	;cp #1
	;jr z,draw_square
	;ld a,e_change(ix)
	;cp #1
	;jr nz,mem_ptr
	;draw_square:
	;ld		a,#0xC0
	call 	cpct_drawSolidBox_asm
	mem_ptr:
	;; Calculate new Video Memory Pointer
	ld		de, #screen_start
	ld		 c, e_x(ix)	
	ld		 b, e_y(ix)
	call	cpct_getScreenPtr_asm

	;;Store Video Memory Pointer as Last
	ld		e_lastVP_l(ix), l
	ld 		e_lastVP_h(ix), h
	ld      a,e_w(ix)
	ld 		e_lastW(ix),a
	;;call cpct_getScreenToSprite
	;; Draw Entity Sprite
	;;ex	de, hl
	;;ld	 l, e_pspr_l(ix)
	;;ld	 h, e_pspr_h(ix)
	;;pop	bc
	;;call cpct_drawSprite_asm

	;;Draw Entity Sprite
	ex	de, hl

	ld	 l, e_sprite_l(ix)
	ld	 h, e_sprite_h(ix)
	ld	 b, #31
	;ld a,e_w(ix)
	;add a
	;ld c,a
	ld c,e_w(ix)

	;ld a,e_action(ix)
	
	;jr nc,_normal_sprite
	;;ld	a,(_ent_counter)
	;;cp #1
	;;jr z,normal_sprite
	;;call cpct_drawSpriteMasked_asm
	;;jr entity_counter
;normal_sprite:
	call cpct_drawSprite_asm
	;jr entity_counter
;_normal_sprite:
	;call cpct_drawSprite_asm
	;;Draw entity square
	;ex 	de, hl
	;call cpct_waitVSYNC_asm
	;ld 	a, e_pspr_l(ix)    ;; Color
	;ld  c, e_w(ix)	;; Width
	;ld  b, e_h(ix)	;; Height
	;call cpct_drawSolidBox_asm ;;[x]
 entity_counter:
_ent_counter = .+1
	ld	a, #0
	dec	a
	ret	z

	ld	(_ent_counter), a
	ld	bc, #sizeof_e
	add	ix, bc
	jr	_update_loop

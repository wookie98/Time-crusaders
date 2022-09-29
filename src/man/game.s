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
;; GAME SYSTEM MANAGER
;;
   .include "cpctelera.h.s"
   .include "man/entity_manager.h.s"
   .include "man/menu_manager.h.s"
   .include "sys/render_system.h.s"
   .include "sys/physics_system.h.s"
   .include "sys/input_system.h.s"
   .include "cmp/entity.h.s"
   .include "sys/sprite_system.h.s"
   .include "sys/fight_system.h.s"
   .include "sys/ai_system.h.s"
   .include "cpct_functions.h.s"
   ;;.globl _sprite_stance

;;=============================================================================================================
;; Manager Member Variables
player: DefineCmp_Entity 20, 169, 0, 0, 8, 120,   _sprite_stance, #stance, 0, 100, 0, 0, 0,	8 ;;SupuestoSprite(Tengo que crear un png en img/, lo configuro en cfg/ para que incluya el png y pongo aquí el nombre que le de)
enemy:	DefineCmp_Entity 50, 169, 0, 0, 8, 120, _sprite_f_stance, #stance, 0, 100, 0, 0, 0,	8

;;=============================================================================================================
;; Manager Public Functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Game::Init
;; Initializes the Game Manager to start a new game
;; INPUT:
;; DESTROYS:
;;
man_game_init::
	;; Init Entity Manager
	call man_entity_init
	;; Init systems
	call man_entity_getArray
	call man_entity_vida
	call sys_render_init
	call man_entity_getArray
	call sys_physics_init
	call sys_render_fondo
	call man_menu_init		;;Aquí va a saltar el menú
	ld 	 (hl),	#1
	call man_entity_getArray
	call sys_ai_init

	inc hl					;;Aquí hago que el update del juego tenga IA o no
	ld 	a,	(hl)
	dec a
	jr	nz,	PlayerVsPlayer

PlayerVsIA:

	ld	de,	#sys_ai_update
	ld (IA_OR_NOT_TO_IA),	de
	ld	a,	r
	ld 	b,	l					;;Esto es para guardar el valor de l
	ld	l,	a
	call cpct_setSeed_lcg_u8_asm
	jr	endif3

PlayerVsPlayer:

	ld	de,	#NO_IA
	ld (IA_OR_NOT_TO_IA),	de

endif3:

	ld	l,	b
	call man_entity_getArray
	call sys_input_init
	;call sys_action_init
	;;call sys_fight_init

	;; Init 2 Test Entities
	ld 	hl, #player
    call man_entity_create
    ld	hl, #enemy
    call man_entity_create
    call sys_render_fondo
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Game::Update
;; Updates 1 game cycle except the rendering.
;; INPUT:
;; DESTROYS:
;;
man_game_update::
	
	call sys_input_update

	IA_OR_NOT_TO_IA = . + 1		;;Aquí dependiendo de si hay IA o no la llamara o no
	call #0x0000

	call man_entity_getArray
    call sys_action_update
    call sys_fight_check
	call sys_physics_update

NO_IA:							;;Etiqueta a donde ira el call que puede llamar a IA si no la hay
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Game::Render
;; Does rendering process to account for its time constraints
;; INPUT:
;; DESTROYS:
;;
man_game_render::
	call sys_render_update
	ret
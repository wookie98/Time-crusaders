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
;; ENTITY MANAGER
;;

.include "entity_manager.h.s"
.include "cmp/array_structure.h.s"
.include "cmp/entity.h.s"
.include "cpctelera.h.s"

;;=============================================================
;; Manager Member Variables
max_entities == 5
initial_position == 1
level_easy == 1
one_player == 1

;;-----------------Entity Components---------------------------
DefineComponentArrayStructure _entity, max_entities, DefineCmp_Entity_default
gameStatus: GameMode initial_position, level_easy, one_player
;;Por vuestra vida las palabras todas seguidas, thax bro
frase: 	Palabra  32,  67,  79,  77,  66,  65,  84,  32,  84		;;Combat T
		Palabra  69,  78,  68,  69,  78,  67,  89,  32,  32		;;endency
		Palabra  78, 101, 119,  32,  71,  97, 109, 101,  32		;;New Game
		Palabra  68, 105, 102, 102, 105,  99, 117, 108, 116		;;Difficult
		Palabra 121,  58,  32,  69,  97, 115, 121,  32,  32		;;y: Easy
		Palabra 121,  58,  32,  77, 101, 100, 105, 117, 109		;;y: Medium
		Palabra 121,  58,  32,  72,  97, 114, 100,  32,  32		;;y: Hard
		Palabra  74,  49,  32, 118, 115,  32,  73,  65,  32		;;J1 vs IA
		Palabra  74,  49,  32, 118, 115,  32,  74,  50,  32		;;J1 vs J2
		Palabra  32,  32,  32,  32,  85, 112,  58,  32,  81		;;Up: Q
		Palabra  32,  32,  68, 111, 119, 110,  58,  32,  65		;;Down: A
		Palabra  83, 101, 108, 101,  99, 116,  58,  32,  67		;;Select: C
Vida:	palabraCorta  80,  49									;;P1
		palabraCorta  80,  50									;;P2
Ganador:	Palabra  89,  79,  85,  32,  87,  73,  78,  33,  33		;;You win!!
Perdedor:	Palabra  89,  79,  85,  32,  76,  79,  83,  69,  33		;;You lose!
;;=============================================================
;;=============================================================
;; Manager Public Functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::getArray
;; Gets a pointer to the array of entities in IX and
;; also the number of entities in A
;; INPUT: -
;; DESTROYS: A, IX
;; RETURNS:
;;		A:	Number of entities in the array
;; 	   IX:	Pointer to the start of the array
man_entity_loser::
	ld 	iy, #Perdedor			;;BEWARE Aqui no hay ret asi que tambien devolvera hl
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::getArray
;; Gets a pointer to the array of entities in IX and
;; also the number of entities in A
;; INPUT: -
;; DESTROYS: A, IX
;; RETURNS:
;;		A:	Number of entities in the array
;; 	   IX:	Pointer to the start of the array
man_entity_winner::
	ld 	iy, #Ganador			;;BEWARE Aqui no hay ret asi que tambien devolvera hl
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::getArray
;; Gets a pointer to the array of entities in IX and
;; also the number of entities in A
;; INPUT: -
;; DESTROYS: A, IX
;; RETURNS:
;;		A:	Number of entities in the array
;; 	   IX:	Pointer to the start of the array
man_entity_vida::
	ld 	hl, #Vida			;;BEWARE Aqui no hay ret asi que tambien devolvera hl
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::getArray
;; Gets a pointer to the array of entities in IX and
;; also the number of entities in A
;; INPUT: -
;; DESTROYS: A, IX
;; RETURNS:
;;		A:	Number of entities in the array
;; 	   IX:	Pointer to the start of the array
man_entity_getString::
	ld 	iy, #frase			;;BEWARE Aqui no hay ret asi que tambien devolvera hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::getArray
;; Gets a pointer to the array of entities in IX and
;; also the number of entities in A
;; INPUT: -
;; DESTROYS: A, IX
;; RETURNS:
;;		A:	Number of entities in the array
;; 	   IX:	Pointer to the start of the array
man_entity_getGameStatus::
	ld 	hl, #gameStatus
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::getArray
;; Gets a pointer to the array of entities in IX and
;; also the number of entities in A
;; INPUT: -
;; DESTROYS: A, IX
;; RETURNS:
;;		A:	Number of entities in the array
;; 	   IX:	Pointer to the start of the array
man_entity_getArray::
	ld 	de, #_entity_array
	ld 	bc, #_entity_num
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::Init
;; Initializes the entity manager.
;; INPUT: -
;; DESTROYS: AF, IX
man_entity_init::
	;;Reset all component vector values
	xor		a 
	ld 		(_entity_num), a

	ld 		hl, #_entity_array
	ld 		(_entity_pend), hl

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::new
;; Adds a new entity component to the array 
;; whiout initializing it.
;; INPUT: -
;; DESTROYS: F, BC, DE, HL
;; RETURNS:
;;	   DE:	Points to added element
;; 	   BC:	Sizeof (Entity_t)
;;
man_entity_new::
	;;Increment number of reserved entities
	ld	hl, #_entity_num
	inc	(hl)
	;;ld (_entity_num), hl

	;;Increment Array end pointer to point to the next
	;;free element in the array
	ld 		hl, (_entity_pend)
	ld 		 d, h
	ld 		 e, l
	ld 		bc, #sizeof_e
	add 		hl, bc
	ld 		(_entity_pend), hl

	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::create
;; Creates and initializes a new entity
;; whiout initializing it.
;; INPUT: 
;;	 HL: Pointer to initializer values for
;;		 the entity to be created
;; DESTROYS: F, BC, DE, HL
;; STACK USE: 2 bytes
;; RETURNS:
;;	   IX: pointer to the component created
;;
;man_menu_update::
;	call	man_entity_new
;
;	;; IX = DE
;	ld__ixh_d
;	ld__ixl_e
;
;	ldir	;; Copy to DE from HL the number of bytes that BC says
;
;	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Man_Entity::create
;; Creates and initializes a new entity
;; whiout initializing it.
;; INPUT: 
;;	 HL: Pointer to initializer values for
;;		 the entity to be created
;; DESTROYS: F, BC, DE, HL
;; STACK USE: 2 bytes
;; RETURNS:
;;	   IX: pointer to the component created
;;
man_entity_create::
	push	hl
	call	man_entity_new

	;; IX = DE
	ld__ixh_d
	ld__ixl_e

	pop hl
	ldir	;; Copy to DE from HL the number of bytes that BC says

	ret
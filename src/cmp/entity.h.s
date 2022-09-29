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

;;Entity COMPONENT
;;	2B Position			{x, y}
;;	2B Velocity			{vx, vy}
;;	2B Size				{sx, sy}
;;	2B Sprite Pointer	{pspr}
;;	2B Last Video Pointer	{lastVP}
;;

;;
;; Defines a New ENtity t component
;;
.macro DefineCmp_Entity _x, _y, _vx, _vy, _w, _h, _sprite, _action, _nxtaction, _lp, _actcd, _hit,_change,_lastW
	.db	 	_x,  _y				;;Position
	.db 	_vx, _vy			;;Velocity
	.db	 	_w,  _h				;;Size
	.dw  	_sprite				;;Sprite pointer
	.dw  	0xC550				;;Last Video Memory Pointer Value
	.db		_action, _nxtaction	;;The action the entity is doing and the next
	.db		_lp					;;Puntos de vida
	.db 	_actcd				;;Tiempo cooldown
	.db		_hit				;; true if fight resolved something
	.db		_change				;; true if the sprite just changed
	.db		_lastW
.endm

tamano_estandar = 8
 _VSalto = -7

;; Entity_t offsets
e_x   		= 0
e_y   		= 1
e_vx  		= 2
e_vy  		= 3
e_w   		= 4
e_h   		= 5
e_sprite_l 	= 6
e_sprite_h 	= 7
e_lastVP_l	= 8
e_lastVP_h	= 9
e_action	= 10
e_nxtaction	= 11
e_lp 		= 12
e_actcd		= 13 ;; action cooldown
e_hit		= 14
e_change	= 15
e_lastW		= 16
sizeof_e	= 17 ;; 16 bytes per Entity Component

;;foe offsets
f_x   		= 0+sizeof_e
f_y   		= 1+sizeof_e
f_vx  		= 2+sizeof_e
f_vy  		= 3+sizeof_e
f_w   		= 4+sizeof_e
f_h   		= 5+sizeof_e
f_sprite_l 	= 6+sizeof_e
f_sprite_h 	= 7+sizeof_e
f_lastVP_l	= 8+sizeof_e
f_lastVP_h	= 9+sizeof_e
f_action	= 10+sizeof_e
f_nxtaction	= 11+sizeof_e
f_lp		= 12+sizeof_e
f_actcd 	= 13+sizeof_e
f_hit		= 14+sizeof_e
f_change	= 15+sizeof_e

stance 		= 0
guard  		= 1
duck  		= 2
jump  		= 3
punch   	= 4
kick   		= 5
low_punch   = 6
low_kick 	= 7
superman 	= 8
jump_kick	= 9
duck_guard	= 10
tkdmg		= 11
;ACCIONES DE LA IA
moving		= 12
dash		= 13
;;after math of the fight
KO			= 14
winner		= 15

.macro	Palabra _1, _2, _3, _4, _5, _6, _7, _8, _9	;;Palabra con 9 letras
	.db	 	_1
	.db 	_2
	.db	 	_3
	.db  	_4
	.db 	_5
	.db		_6
	.db		_7
	.db		_8
	.db		_9
	.db		0		;;Value null
.endm

.macro	palabraCorta _1, _2	;;Palabra con 2 letras
	.db	 	_1
	.db 	_2
	.db		0		;;Value null
.endm

sizeof_word		= 10
sizeof_2words	= 20

.macro GameMode _position_menu, _levelAI, _numberPlayers
	_menu_position:	.db	_position_menu		;;It says the position in the menu if it's 4 then the game starts
	_game_level:	.db	_levelAI			;;1=easy, 2=medium, 3=hard
	_game_players:	.db	_numberPlayers		;;1=PlayerVersusIA, 2=PlayerVersusPlayer
.endm

;; Default constructor for Entity Component
.macro DefineCmp_Entity_default
	DefineCmp_Entity 0, 0, 0, 0, 1, 1, 0x0000, 0, 0, 0, 0, 0,0,0
.endm
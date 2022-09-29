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
;;	MENU SYSTEM
;;

.include "sys/render_system.h.s"
.include "man/entity_manager.h.s"
.include "sys/input_system.h.s"

;;=============================================================================================================
;;POSIBLE MEJORA SUSTITUYENDO LOS GET POR CODIGO AUTOMODIFICABLE
;;Por temas de falta de tiempo y que al ser el menu en el cual no es necesaria eficiencia lo voy a dejar asi por el momento
man_menu_init::
	call 	man_entity_getString		;;Devuelve en IY el puntero al string y en HL el puntero a gameStatus
	call 	sys_render_menu 			;;Muestra el menú
	call 	man_entity_getGameStatus	;;Devuelve en HL el puntero a gameStatus
	call 	sys_input_menu				;;Busca cambios en las letras
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
	call 	man_entity_getGameStatus	;;Devuelve en HL el puntero a gameStatus
	ld		a, 	(hl)
	sub 	a,	#4						;;Comprueba si el juego ha sido comenzado o no
	jr		nz,	man_menu_init			;;Loop momentaneo mientras hago el menu
	ret
	
	
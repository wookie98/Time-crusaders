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
;; COMPONENT ARRAY STRUCTURE
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate data structure and array of type-T components
;; It generates these labels:
;;		Name_num:	a byte to count the number of items in the array
;;		Name_pend:  a word to store the pointer to he end of the array
;;		Name_array: the array
;; INPUTS:
;;		_Tname:	Name of the component type
;;		_N:		Number of components that the array has
;;		_DefineTypeMacroDefault: Macro to be called to generate the entities
.macro DefineComponentArrayStructure _Tname, _N, _DefineTypeMacroDefault
	_Tname'_num:	.db 0
	_Tname'_pend:	.dw _Tname'_array
	_Tname'_array:
	.rept _N
		_DefineTypeMacroDefault
	.endm
.endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Same macro as before but generating zeros instead of a structure
;; INPUTS:
;;		Same as before except,
;;		_ComponentSize: Size in bytes of ont component
.macro DefineComponentArrayStructure_Size _Tname, _N, _ComponentSize
	_Tname'_num:	.db 0
	_Tname'_pend:	.dw _Tname'_array
	_Tname'_array:
		.ds _N * _ComponentSize
.endm

.macro DefineCmp_Sprites _stance, _guard, _duck, _jump, _punch, _kick, _low_punch, _low_kick, _superman, _jump_kick, _duck_guard, _tkdamage, _moving, _ko, _winner
	.dw		_stance		
	.dw 	_guard			
	.dw	 	_duck			
	.dw  	_jump			
	.dw  	_punch			
	.dw		_kick	
	.dw		_low_punch	
	.dw 	_low_kick
	.dw		_superman
	.dw		_jump_kick
	.dw		_duck_guard
	.dw		_tkdamage
	.dw		_moving
	.dw		_ko
	.dw		_winner
.endm

.macro DefineCmp_ActionBasedParameters _stance, _guard, _duck, _jump, _punch, _kick, _low_punch, _low_kick, _superman, _jump_kick, _duck_guard, _tkdamage, _moving,_ko, _winner
	.db		_stance		
	.db 	_guard			
	.db	 	_duck			
	.db  	_jump			
	.db  	_punch			
	.db		_kick	
	.db		_low_punch					
	.db 	_low_kick
	.db		_superman
	.db		_jump_kick
	.db		_duck_guard
	.db 	_tkdamage
	.db 	_moving
	.dw		_ko
	.dw		_winner
.endm


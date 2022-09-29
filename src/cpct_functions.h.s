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
;; CPCTELERA FUNCTIONS
;;

   .globl cpct_disableFirmware_asm
   .globl cpct_waitVSYNC_asm
   .globl cpct_getScreenPtr_asm
   .globl cpct_drawSolidBox_asm
   .globl cpct_scanKeyboard_f_asm
   .globl cpct_isKeyPressed_asm
   .globl cpct_setVideoMode_asm
   .globl cpct_setPalette_asm
   .globl cpct_drawSprite_asm
   .globl cpct_drawStringM0_asm
   .globl cpct_setDrawCharM0_asm
   .globl cpct_drawSpriteMasked_asm
   .globl cpct_drawSpriteBlended_asm
   .globl cpct_setSeed_lcg_u8_asm
   .globl cpct_getRandom_lcg_u8_asm
   ;.globl cpct_getScreenToSprite

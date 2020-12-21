Global $AutoMoveDummy = False
AutoMoveStop()
Sleep(2147483647)

Func AutoMove()
   HotKeySet("{F7}", "AutoMoveStop")
   Local $aPos = WinGetPos("[ACTIVE]")
   Global $AutoMoveDummy = True
   While $AutoMoveDummy
	  Local $aCoord = PixelSearch($aPos[0], $aPos[1] + 20, $aPos[0] + $aPos[2], $aPos[1] + $aPos[3], 0xBDCF46, 0, 5)
	  If Not @error Then
		 MouseMove($aCoord[0] - 10, $aCoord[1], 0)
	  EndIf
   WEnd
EndFunc

Func AutoMoveStop()
   HotKeySet("{F7}", "AutoMove")
   Global $AutoMoveDummy = False
EndFunc
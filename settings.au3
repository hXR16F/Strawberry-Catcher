#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include "JSONgen.au3"

#Region ### START Koda GUI section ###
$Form1 = GUICreate("Strawberry Catcher Settings", 386, 259, 206, 225)
$Group1 = GUICtrlCreateGroup("Graphics", 24, 16, 337, 113)
$Combo1 = GUICtrlCreateCombo("", 40, 40, 89, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "640x480|800x600|1024x768|1440x1080|1600x1200|1280x800|1440x900|1680x1050|1920x1200|1280x720|1366x768|1600x900|1920x1080|2560x1440|3840x2160", "1280x720")
$Checkbox1 = GUICtrlCreateCheckbox("Fullscreen", 144, 42, 81, 17)
$Checkbox3 = GUICtrlCreateCheckbox("Screen flashing", 40, 72, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Checkbox4 = GUICtrlCreateCheckbox("Font antialiasing", 40, 96, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Save", 23, 216, 123, 25)
GUICtrlSetCursor (-1, 0)
$Group2 = GUICtrlCreateGroup("Sounds", 24, 144, 337, 57)
$Checkbox2 = GUICtrlCreateCheckbox("Music", 40, 168, 57, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Checkbox5 = GUICtrlCreateCheckbox("Sounds", 104, 168, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button2 = GUICtrlCreateButton("Save and launch game", 159, 216, 203, 25)
GUICtrlSetCursor (-1, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$oJson = New_Json()

While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
	  Case $GUI_EVENT_CLOSE
		 Exit
	  Case $Button1
		 save()
		 MsgBox($MB_ICONINFORMATION + $MB_OK, "Strawberry Catcher Settings", "Saved.")
	  Case $Button2
		 save()
		 If FileExists("StrawberryCatcher.exe") Then
			Run("StrawberryCatcher.exe")
		 Else
			Run(@ComSpec & " /k " & "py main.py", "", @SW_HIDE)
		 EndIf
   EndSwitch
WEnd

Func _IsChecked($idControlID)
   Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc

Func save()
   Global $resolution = GUICtrlRead($Combo1)
   Global $fullscreen = _IsChecked($Checkbox1)
   Global $flashing = _IsChecked($Checkbox3)
   Global $music = _IsChecked($Checkbox2)
   Global $sounds = _IsChecked($Checkbox5)

   Json_AddElement($oJson, "resolution", $resolution)
   Json_AddElement($oJson, "fullscreen", $fullscreen)
   Json_AddElement($oJson, "flashing", $flashing)
   Json_AddElement($oJson, "music", $music)
   Json_AddElement($oJson, "sounds", $sounds)

   If FileExists("settings.json") Then
	  FileDelete("settings.json")
   EndIf

   FileWrite("settings.json", Json_GetJson($oJson))
EndFunc
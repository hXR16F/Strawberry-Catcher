#cs
	JSONgen - JSON generator for AutoIt
	Taken as base JSON spec at json.org
#ce

#include-once


Func New_JSON()
	Dim $aSelf[1][3]
	Return $aSelf
EndFunc

Func JSON_AddElement(ByRef $aSelf, $sKey, $sValue = Default)
		$this = UBound($aSelf)
		ReDim $aSelf[$this+1][3]
	If $sValue <> Default Then
		$aSelf[$this][1] = $sKey
		$aSelf[$this][2] = $sValue
		Return $aSelf
	Else
		$aSelf[$this][1] = $sKey
		$aSelf[$this][2] = Default
	EndIf
EndFunc

Func JSON_GetJson($aSelf, $bHumanReadable = False)
	$sOutput = "{"

	$j = UBound($aSelf)-1

	For $i = 1 To $j

		$iThis = $i-1
		$sKey = $aSelf[$i][1]
		$sValue = $aSelf[$i][2]

		If IsArray($sKey) And $sValue = Default Then
			; Stand-alone array
			$sOutput &= '"' & $iThis & '":' & __JSON_ArrayHelper($sKey)
			$sOutput &= ","
		ElseIf IsString($sKey) And $sValue = Default Then
			; Stand-alone string/int
			$sOutput &= '"' & $iThis & '":"' & __JSON_Filter($sKey) & '",'
		ElseIf IsString($sKey) And Not IsArray($sValue) Then
			; Associated (str)key=>(mix)value
			If IsString($sValue) Then
				$sOutput &= '"' & __JSON_Filter($sKey) & '":"' & __JSON_Filter($sValue) & '",'
			ElseIf IsNumber($sValue) Then
				$sOutput &= '"' & __JSON_Filter($sKey) & '":' & $sValue & ","
			ElseIf IsBool($sValue) Then
				$sOutput &= '"' & __JSON_Filter($sKey) & '":' & ($sValue ? 'true' : 'false') & ','
			ElseIf $sValue = Null Then
				$sOutput &= '"' & __JSON_Filter($sKey) & '":null,'
			EndIf
		ElseIf IsString($sKey) And IsArray($sValue) Then
			; Associated (str)key=>(arr)value
			$sOutput &= '"' & __JSON_Filter($sKey) & '":' & __JSON_ArrayHelper($sValue) & ','
		EndIf
	Next

	$sOutput = StringTrimRight($sOutput, 1) & "}"

	; Let's make it more human-readable
	If $bHumanReadable Then
		$sOutput = StringReplace($sOutput, "{", "{ ")
		$sOutput = StringReplace($sOutput, "}", " }")
		$sOutput = StringReplace($sOutput, ",", ", ")
		$sOutput = StringReplace($sOutput, ":", ": ")
		$sOutput = StringReplace($sOutput, "[", " [ ")
		$sOutput = StringReplace($sOutput, "]", " ] ")
	EndIf

	Return $sOutput
EndFunc

; =========== internal use only ==============
Func __JSON_Filter($sValue)
	$sValue = StringReplace($sValue, '"', '\"')
	$sValue = StringReplace($sValue, '\', '\\')
	$sValue = StringReplace($sValue, @CRLF, '\n')
	$sValue = StringReplace($sValue, @CR, '\n')
	$sValue = StringReplace($sValue, @LF, '\n')
	Return $sValue
EndFunc

Func __JSON_ArrayHelper($aArr)
	$output = "["
	For $mItem In $aArr
		If IsNumber($mItem) Then
			$output &= $mItem
		ElseIf IsString($mItem) Then
			$output &= '"' & __JSON_Filter($mItem) & '"'
		ElseIf IsBool($mItem) Then
			$output &= ($mItem ? 'true' : 'false')
		ElseIf IsArray($mItem) Then
			$output &= __JSON_ArrayHelper($mItem)
		EndIf
		$output &= ","
	Next
	$output = StringTrimRight($output, 1) & "]"
	Return $output
EndFunc
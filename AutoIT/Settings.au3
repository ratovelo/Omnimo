#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icons\Omnimo.ico
#AutoIt3Wrapper_Outfile=..\WP7\@Resources\Common\Settings\settings.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Made for Omnimo UI
#AutoIt3Wrapper_Res_Description=Omnimo Settings Tool
#AutoIt3Wrapper_Res_Fileversion=6.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Xyrfo 2013
#AutoIt3Wrapper_AU3Check_Parameters=-q -w 1 -w 2 -w 3 -w 4 -w 6 -w 7 -w 8
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <Misc.au3>
#include <File.au3>

#include "Includes\Common.au3"
#include "Includes\_Startup.au3"

Const $VariablesFile = @ScriptDir & '\..\Variables\UserVariables.inc'
Const $SettingsVariables = @ScriptDir & "\UserVariables.inc"

Const $OmnimoTray = Int(IniRead($SettingsVariables, "Variables", "OmnimoTray", "0"))
Const $Icons = Int(IniRead($SettingsVariables, "Variables", "Icons", "0"))
Const $Startup = Int(IniRead($SettingsVariables, "Variables", "Startup", "0"))
Const $CurrentLanguage = IniRead($SettingsVariables, "Variables", "Language", "English")
Const $Hotkey = IniRead($SettingsVariables, "Variables", "Hotkey", "F8")
Const $RainmeterPath = IniRead($SettingsVariables, "Variables", "RainmeterPath", "") & "\Rainmeter.exe"
Const $LangFile = @ScriptDir & "\Language\" & $CurrentLanguage & ".cfg"

If Not FileExists($LangFile) Then OmnimoError("Error loading language", "Unable to load language file for " & $CurrentLanguage)

$LangCodes = ObjCreate("Scripting.Dictionary")
$LangCodes.Add("English", "1033")
$LangCodes.Add("French", "1036")
$LangCodes.Add("Portuguese", "1046")
$LangCodes.Add("Russian", "1049")
$LangCodes.Add("German", "1031")
$LangCodes.Add("Finnish", "1035")
$LangCodes.Add("Spanish", "1034")

; Read language dictionary from file
$Language = ObjCreate("Scripting.Dictionary")
$Sections = IniReadSection($LangFile, "Variables")
For $i = 1 To $Sections[0][0]
	$Language.Add($Sections[$i][0], $Sections[$i][1])
Next

$Gui = GUICreate("Omnimo Settings", 340, 400, Default, Default, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX))
GUISetBkColor(0xFFFFFF)

; Title
GUICtrlCreateLabel($Language.Item("Options"), 16, 16, 141, 28)
GUICtrlSetFont(-1, 13, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x376DD0)

; Footer
GUICtrlCreateGraphic(0, 355, 340, 45)
GUICtrlSetColor(-1, 0xF0F0F0)
GUICtrlSetBkColor(-1, 0xF0F0F0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGraphic(0, 353, 340, 1)
GUICtrlSetColor(-1, 0x898C95)

$Cancel = GUICtrlCreateButton($Language.Item("Cancel"), 248, 365, 81, 25)
$OK = GUICtrlCreateButton("OK", 160, 365, 81, 25)

; Group labels
$Line1X = StringLen($Language.Item("Interface")) * 5 + 35
$Line2X = StringLen($Language.Item("Settings")) * 5 + 35
$Line3X = StringLen($Language.Item("Integration")) * 5 + 35

GUICtrlCreateLabel($Language.Item("Interface"), 16, 48, 200, 17)
GUICtrlSetColor(-1, 0x636363)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateGraphic($Line1X, 55, 315 - $Line1X, 1)
GUICtrlSetColor(-1, 0xD8D8D8)
GUICtrlCreateLabel($Language.Item("Settings"), 16, 112, 200, 17)
GUICtrlSetColor(-1, 0x636363)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateGraphic($Line2X, 119, 315 - $Line2X, 1)
GUICtrlSetColor(-1, 0xD8D8D8)
GUICtrlCreateLabel($Language.Item("Integration"), 16, 264, 200, 17)
GUICtrlSetColor(-1, 0x636363)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateGraphic($Line3X, 272, 315 - $Line3X, 1)
GUICtrlSetColor(-1, 0xD8D8D8)

; Options
GUICtrlCreateLabel($Language.Item("Language"), 35, 80, 125, 17)
GUICtrlCreateLabel($Language.Item("Location"), 35, 226, 85, 17)
GUICtrlCreateLabel($Language.Item("Hotkey"), 35, 197, 85, 17)

$LangSelect = GUICtrlCreateCombo("", 165, 80, 123, 25, $CBS_DROPDOWNLIST)
$LocationSelect = GUICtrlCreateCombo("", 122, 224, 193, 21)
$HotkeySelect = GUICtrlCreateCombo("", 122, 194, 193, 20)
$TrayIconOpt = GUICtrlCreateCheckbox($Language.Item("HideTrayIcon"), 35, 142, 250, 17)
$MetricOpt = GUICtrlCreateCheckbox($Language.Item("Metric"), 35, 167, 250, 17)
$StartupOpt = GUICtrlCreateCheckbox($Language.Item("Startup"), 35, 292, 250, 17)
$IconsOpt = GUICtrlCreateCheckbox($Language.Item("Icons"), 35, 314, 250, 25)

If IniRead($VariablesFile, "Variables", "DisplayAMPM", "1") == "1" Then GUICtrlSetState($MetricOpt, $GUI_CHECKED)
If IniRead(@AppDataDir & "\Rainmeter\Rainmeter.ini", "Rainmeter", "TrayIcon", "1") == "0" Then GUICtrlSetState($TrayIconOpt, $GUI_CHECKED)
If $OmnimoTray Then GUICtrlSetState($TrayIconOpt, $GUI_CHECKED)
If $Startup Then GUICtrlSetState($StartupOpt, $GUI_CHECKED)
If $Icons Then GUICtrlSetState($IconsOpt, $GUI_CHECKED)

$Langlist = _FileListToArray(@ScriptDir & "\Language", "*.cfg")
$Languages = ""
For $i = 1 To $Langlist[0]
	$Languages &= StringTrimRight($Langlist[$i], 4) & "|"
Next

GUICtrlSetData($LangSelect, $Languages, $CurrentLanguage)
GUICtrlSetData($HotkeySelect, "None|F6|F7|F8|F9|F10", $Hotkey)

; Info buttons
GUICtrlCreatePic(@ScriptDir & "\info.jpg", 299, 83, 16, 16)
GUICtrlSetTip(-1, $Language.Item("TranslationsTip"), $Language.Item("TranslationsTipTitle"), 1, 1)

GUICtrlCreatePic(@ScriptDir & "\info.jpg", 299, 146, 16, 16)
GUICtrlSetTip(-1, $Language.Item("TrayIconTip"), $Language.Item("TrayIconTipTitle"), 1, 1)

GUICtrlCreatePic(@ScriptDir & "\info.jpg", 299, 319, 16, 16)
GUICtrlSetTip(-1, $Language.Item("IconsTip"), $Language.Item("IconsTipTitle"), 1, 1)

GUISetState(@SW_SHOW)
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

; Initialize variables
Global $aResult, $iRows, $iColumns, $iRval, $aRow, $hQuery, $prev_len = 0

_SQLite_Startup()
Const $db = _SQLite_Open(@ScriptDir & "\weather.db")

; Match current weather code with location
$Code = IniRead($VariablesFile, "Variables", "GlobalWeatherCode", "UKXX0085")
_SQLite_Query($db, "SELECT city FROM cities WHERE code=='" & $Code & "';", $hQuery)

If _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK Then
	_GUICtrlComboBox_SetEditText($LocationSelect, $aRow[0])
Else
	_GUICtrlComboBox_SetEditText($LocationSelect, "London, United Kingdom")
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Cancel
			Exit

		Case $OK
			Const $TraySelected = _Iif(GUICtrlRead($TrayIconOpt) = $GUI_CHECKED, 1, 0)
			Const $IconsSelected = _Iif(GUICtrlRead($IconsOpt) = $GUI_CHECKED, "1", "0")

			IniWrite(@AppDataDir & "\Rainmeter\Rainmeter.ini", "Rainmeter", "TrayIcon", -1 * $TraySelected + 1)
			IniWrite($SettingsVariables, "Variables", "OmnimoTray", $TraySelected)
			IniWrite($SettingsVariables, "Variables", "Icons", $IconsSelected)
			IniWrite($SettingsVariables, "Variables", "Hotkey", GUICtrlRead($HotkeySelect))

			If GUICtrlRead($StartupOpt) = $GUI_CHECKED Then
				If _StartupFolder_Install("Omnimo", @ScriptDir & "\Omnimo.exe") Then
					IniWrite($SettingsVariables, "Variables", "Startup", "1")
				EndIf
			Else
				If _StartupFolder_Uninstall("Omnimo", @ScriptDir & "\Omnimo.exe") Then
					IniWrite($SettingsVariables, "Variables", "Startup", "0")
				EndIf
			EndIf

			Const $Lang = GUICtrlRead($LangSelect)
			Const $LanguageFile = @ScriptDir & "\..\Variables\Languages\" & $Lang & ".inc"
			FileCopy($LanguageFile, @ScriptDir & "\..\Variables\Languages\lang.inc", 1)
			IniWrite($SettingsVariables, "Variables", "Language", $Lang)
			If $LangCodes.Exists($Lang) Then
				IniWrite(@AppDataDir & "\Rainmeter\Rainmeter.ini", "Rainmeter", "Language", $LangCodes.Item($Lang))
			EndIf

			If GUICtrlRead($MetricOpt) = $GUI_CHECKED Then
				IniWrite($VariablesFile, "Variables", "TimeFormat", "%H:%M")
				IniWrite($VariablesFile, "Variables", "DisplayAMPM", "1")
				IniWrite($VariablesFile, "Variables", "TemperatureFormat", "c")
				IniWrite($VariablesFile, "Variables", "TemperatureFormat2", "m")
			Else
				IniWrite($VariablesFile, "Variables", "TimeFormat", "%I:%M")
				IniWrite($VariablesFile, "Variables", "DisplayAMPM", "0")
				IniWrite($VariablesFile, "Variables", "TemperatureFormat", "f")
				IniWrite($VariablesFile, "Variables", "TemperatureFormat2", "i")
			EndIf

			; Fetch weather code from database
			_SQLite_Query($db, "SELECT code FROM cities WHERE city=='" & GUICtrlRead($LocationSelect) & "';", $hQuery)
			If _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK Then
				Const $WeatherCode = $aRow[0]
				IniWrite($VariablesFile, "Variables", "GlobalWeatherCode", $WeatherCode)
			Else
				MsgBox(48, "Warning", "Invalid weather location")
			EndIf

			; Changing language, hotkey or icon toggling requires restarting Omnimo.exe
			If GUICtrlRead($HotkeySelect) <> $Hotkey Or $Icons <> $IconsSelected Or $Lang <> $CurrentLanguage Then
				If $Lang <> $CurrentLanguage Then
					SendBang("!Quit")
					ProcessWaitClose("Rainmeter.exe")
					Run($RainmeterPath)
					ProcessWait("Rainmeter.exe")
				EndIf

				If ProcessExists("Omnimo.exe") Then
					ProcessClose("Omnimo.exe")
					ProcessWaitClose("Omnimo.exe")
					_UpdateTray()
				EndIf

				ShellExecute(@ScriptDir & "\Omnimo.exe")
			EndIf

			If GUICtrlRead($TrayIconOpt) = $GUI_CHECKED Then
				If Not ProcessExists("Omnimo.exe") Then ShellExecute(@ScriptDir & "\Omnimo.exe")
			Else
				ProcessClose("Omnimo.exe")
				ProcessWaitClose("Omnimo.exe")
				_UpdateTray()
			EndIf

			SendBang("!RefreshApp")
			Exit

	EndSwitch
WEnd

_SQLite_Close()
_SQLite_Shutdown()

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg
    If BitShift($iwParam, 16) <> $CBN_EDITCHANGE Then Return
	Const $data = GUICtrlRead($LocationSelect)
	Const $len = StringLen($data)

	; Don't complete when deleting or very short strings
	If $len <= $prev_len Or $len < 3 Then
		$prev_len = $len
		Return
	EndIf

	_GUICtrlComboBox_BeginUpdate($LocationSelect)
	_GUICtrlComboBox_ResetContent(GUICtrlGetHandle($LocationSelect))

	; Search possible locations from current prefix
	$iRval = _SQLite_GetTable($db, "SELECT * FROM cities WHERE city LIKE '" & $data & "%' ORDER BY cindex;", $aResult, $iRows, $iColumns)
	If $iRval = $SQLITE_OK Then
		; Update combobox with the matching locations
		$dd = ""
		For $i = 5 To $aResult[0] Step 3
			$dd &= $aResult[$i] & "|"
		Next
		GUICtrlSetData($LocationSelect, $dd)
	EndIf

	_GUICtrlComboBox_SetEditText($LocationSelect, $data)
	_GUICtrlComboBox_EndUpdate($LocationSelect)

	If $iRval = $SQLITE_OK Then _GUICtrlComboBox_AutoComplete($LocationSelect)
    Return $GUI_RUNDEFMSG
EndFunc

Func _UpdateTray()
    Local $iMode = Opt("WinTitleMatchMode", 4)
    Local $hControl = ControlGetHandle("[CLASS:Shell_TrayWnd]", "", "[CLASSNN:ToolbarWindow321]")
    Local $acSize = WinGetClientSize($hControl)

    For $x = 0 To $acSize[0] Step 5
        For $y = 0 To $acSize[1] Step 5
            DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hControl, "int", 0x0200, "wparam", 0, "lparam", BitOR($y*0x10000, BitAND($x, 0xFFFF)))
        Next
    Next
    Opt("WinTitleMatchMode", $iMode)
EndFunc

#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=images\ico\tcC.ico
#AutoIt3Wrapper_Outfile=tcCalculator.exe
#AutoIt3Wrapper_Res_Comment=Created with AutoIt
#AutoIt3Wrapper_Res_Description=Timecode Calculator
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=tcCalculator
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=NyBumBum
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2024 NyBumBum
#AutoIt3Wrapper_Res_File_Add=images\bmp\200.bmp,2,200
#AutoIt3Wrapper_Res_File_Add=images\bmp\201.bmp,2,201
#AutoIt3Wrapper_Res_File_Add=images\bmp\202.bmp,2,202
#AutoIt3Wrapper_Res_File_Add=images\bmp\203.bmp,2,203
#AutoIt3Wrapper_Res_File_Add=images\bmp\204.bmp,2,204
#AutoIt3Wrapper_Res_File_Add=images\bmp\205.bmp,2,205
#AutoIt3Wrapper_Res_File_Add=images\bmp\206.bmp,2,206
#AutoIt3Wrapper_Res_File_Add=images\bmp\207.bmp,2,207
#AutoIt3Wrapper_Res_File_Add=images\bmp\208.bmp,2,208
#AutoIt3Wrapper_Res_File_Add=images\bmp\209.bmp,2,209
#AutoIt3Wrapper_Res_File_Add=images\bmp\303.bmp,2,303
#AutoIt3Wrapper_Res_File_Add=images\bmp\309.bmp,2,309
#AutoIt3Wrapper_Res_File_Add=localization\en_strings.ini, 6
#AutoIt3Wrapper_Res_File_Add=localization\ru_strings.ini, 6
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;HEY! BEFORE COMPILING, DON'T FORGET TO CHANGE THE PROGRAM VERSION AND COPYRIGHT YEAR IN THE RESOURCES!

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <GuiHotkey.au3> ;(UDF by Mat)
#include <GuiImageList.au3>
#include <GuiMenu.au3>
#include <EditConstants.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include "StringSize.au3" ;(UDF by Melba23)
#include <TabConstants.au3>
#include <WinAPI.au3>
#include <WinAPIGdi.au3>
#include <WinAPIHObj.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>

_FixAccelHotKeyLayout()

Global $nFontSize

Global $sResultTC = ""
Global $iArgumentFirstFrame = 0         ; Start value (do not delete)
Global $iArgumentSecondFrame = 0        ; Start value (do not delete)
Global $iResultFrame = 0                ; Start value (do not delete)
Global $nArithmeticOperation = 0        ; Start value (do not delete)
Global $sTempTC
Global $iError

Global $nFPSMode
Global $nDropSeparatorMode
Global $bTrainingMode
Global $bBadSeparatorMode
Global $bHotKeyMode
Global $nInputMode = 1                  ; Start value (do not delete)

Global $idSelectAll

Global $bDropFrameMode
Global $iFPS
Global $iHours
Global $iMinutes
Global $iSeconds
Global $iFrames
Global $iTotalNumberFrames
Global $iDropPerMinute                  ;2 or 4

Global $hTimer                          ;for Menu Button
Global $iDiff

Global $aBeforeSel
Global $iDiffBeforeSel

Global $aSel
Global $sOld

Global $sSeparatorFirst
Global $sSeparatorSecond
Global $sSeparatorThird

Global $sBadSeparatorFirst
Global $sBadSeparatorSecond
Global $sBadSeparatorThird

Global $sHotKey                         ; format aka Send
Global $iHotKeyCode                     ; for Registry

Local $iSuccess

Global $hInstance = _WinAPI_GetModuleHandle(0)
If $hInstance = 0 Then
	MsgBox($MB_ICONERROR, "Error", "Failed to get program handle.")
	Exit
EndIf

Global $sArchitecture = @OSArch         ;for Registry

#Region;--------------------Localization---------------------------------------------------------(FAQ by Yashied)
Func GetStringFromResources($iStringID)                          ;function to extract strings from a String Table
	Local $iString = _WinAPI_LoadString($hInstance, $iStringID)
	If @error Then
		MsgBox($MB_ICONERROR, "Error", "Failed to get string from program resources.")
		Exit
	EndIf
	Return $iString
EndFunc   ;==>GetStringFromResources

Global $anArrayStringsMain[7] = [6048, 6049, 6050, 6051, 6052, 6053, 6054]
Global Enum $eFormMainTitle, $eButtonMenuTip, $eButtonClearTip, $eButtonFramesTipF, $eButtonFramesTipTC, $eButtonPasteTip, $eButtonCopyTip
Global $anArrayStringsContextMenu_ButtonMenu[4] = [6064, 6065, 6066, 6067]
Global Enum $eAlwaysOnTop, $eSettings, $eHelp, $eAbout
Global $anArrayStringsContextMenu_Input[5] = [6080, 6081, 6082, 6083, 6084]
Global Enum $eCut, $eCopy, $ePaste, $eDelete, $eSelectAll
Global $anArrayStringsSettings[2] = [6096, 6097]
Global Enum $eFormSettingsTitle, $eButtonSave
Global $anArayStringsSettingsTabGeneral[6] = [6112, 6113, 6114, 6115, 6116, 6117]
Global Enum $eTabGeneralTitle, $eGroupFPS, $eLabelFPS, $eGroupTraining, $eCheckBoxTraining, $eLabelTraining
Global $anArayStringsSettingsTabSeparator[7] = [6128, 6129, 6130, 6131, 6132, 6133, 6134]
Global Enum $eTabSeparatorTitle, $eGroupNonDrop, $eLabelNonDrop, $eGroupDrop, $eLabelDrop, $eLabelDrop2, $eLabelWikipedia
Global $anArayStringsSettingsTabTricks[7] = [6144, 6145, 6146, 6147, 6148, 6149, 6150]
Global Enum $eTabTricksTitle, $eGroupBadSeparator, $eCheckboxBadSeparator, $eLabelBadSeparator, $eGroupHotKey, $eCheckboxHotKey, $eLabelHotKey
Global $anArayStringsSettingsTabAbout[6] = [6160, 6161, 6162, 6163, 6164, 6165]
Global Enum $eTabAboutTitle, $eLabelAboutName, $eLabelAboutVersion, $eLabelAboutCopyright, $eLabelAboutComment, $eLabelAboutDisclaimer
Global $anArayStringsErrors[16] = [6016, 6017, 6018, 6019, 6020, 6021, 6022, 6023, 6024, 6025, 6026, 6027, 6028, 6029, 6030, 6031]                                                   ;reserved until 6048
Global Enum $eErrorTitle, $eUnknownError, $eTimecodeInvalid, $eTimecodeIncorrect, $eFramesInvalid, $eFramesOverMax, $eDrop, $eIntegerOverMax, $eResultOverMax, $eNegativeNumber, $eDivideByZero, $eCastomSeparatorEmpty, $eHotKeyRegistrationDenied, $eSavedHotKeyDeniedOnStart, $eHotKeyEmpty, $eAlreadyRunning
#EndRegion;-------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------Checking if already running
If WinExists('[CLASS:AutoIt v3;TITLE:' & @ScriptName & ']') Then
	$iError = 14
	PrintError($iError)
	WinActivate("[REGEXPTITLE:^(tcCalculator \d{2}).*]")
	Exit
EndIf
AutoItWinSetTitle(@ScriptName)
;--------------------------------------------------------------------------------

GetRegistry()

Global $anArrayFPS[8][4] = [[6000, 24, 0, 0], [6001, 25, 0, 0], [6002, 30, 1, 2], [6003, 30, 0, 0], [6004, 48, 0, 0], [6005, 50, 0, 0], [6006, 60, 1, 4], [6007, 60, 0, 0]]    ;reserved until 6016

$iFPS = $anArrayFPS[$nFPSMode][1]
$bDropFrameMode = $anArrayFPS[$nFPSMode][2]
$iDropPerMinute = $anArrayFPS[$nFPSMode][3]

Global Const $asArrayDropSeparators[4][4] = [["00;00;00;00", ";", ";", ";"], ["00:00:00;00", ":", ":", ";"], ["00.00.00.00", ".", ".", "."], ["00:00:00.00", ":", ":", "."]]
Global Const $asArrayNonDropSeparators[1][4] = [["00:00:00:00", ":", ":", ":"]]

ChoosingSeparators()
$nFontSize = CalculateFontSize()

#Region ### START Koda GUI section ### FormMain
$hFormMain = GUICreate("", 261, 329, -1, -1)
WinSetTitle($hFormMain, "", GetStringFromResources($anArrayStringsMain[$eFormMainTitle]) & " " & GetStringFromResources($anArrayFPS[$nFPSMode][0]))
GUISetFont(18, 400, 0, "Segoe UI")
GUISetIcon(@ScriptFullPath, 99)
$idInput = GUICtrlCreateInput("", 0, 0, 261, 68, $ES_CENTER, 0)
GUICtrlSetLimit(-1, 12)
$sTempTC = "00" & $sSeparatorFirst & "00" & $sSeparatorSecond & "00" & $sSeparatorThird & "00"
GUICtrlSetData($idInput, $sTempTC)

#Region ;-------------Context Menu For Input---------------------------------
$hContextMenu_Input = _GUICtrlMenu_CreatePopup()
If $hContextMenu_Input = 0 Then
	MsgBox($MB_ICONERROR, "Error", "Failed to get menu handle.")
	Exit
EndIf

_GUICtrlMenu_AddMenuItem($hContextMenu_Input, GetStringFromResources($anArrayStringsContextMenu_Input[$eCut]), $WM_CUT)                  ;Cut
_GUICtrlMenu_AddMenuItem($hContextMenu_Input, GetStringFromResources($anArrayStringsContextMenu_Input[$eCopy]), $WM_COPY)                ;Copy
_GUICtrlMenu_AddMenuItem($hContextMenu_Input, GetStringFromResources($anArrayStringsContextMenu_Input[$ePaste]), $WM_PASTE)              ;Paste
_GUICtrlMenu_AddMenuItem($hContextMenu_Input, GetStringFromResources($anArrayStringsContextMenu_Input[$eDelete]), $WM_CLEAR)             ;Delete
_GUICtrlMenu_AddMenuItem($hContextMenu_Input, "")
_GUICtrlMenu_AddMenuItem($hContextMenu_Input, GetStringFromResources($anArrayStringsContextMenu_Input[$eSelectAll]), $idSelectAll)       ;Sellect All
#EndRegion ;-------------Context Menu For Input---------------------------------

GUICtrlSetFont(-1, $nFontSize, 400, 0, "Segoe UI")
$idButton_Menu = GUICtrlCreateButton("", 0, 68, 66, 53)
GUICtrlSetTip(-1, GetStringFromResources($anArrayStringsMain[$eButtonMenuTip]))                                                           ;Menu

#Region;------Menu For Button Menu-----------------------------------------------------------------
$idDummy_Menu = GUICtrlCreateDummy()
$idContextMenu_ButtonMenu = GUICtrlCreateContextMenu($idDummy_Menu)
$idContext_AlwaysOnTop = GUICtrlCreateMenuItem(GetStringFromResources($anArrayStringsContextMenu_ButtonMenu[$eAlwaysOnTop]), $idContextMenu_ButtonMenu)          ;"Always On Top"
$idContext_Settings = GUICtrlCreateMenuItem(GetStringFromResources($anArrayStringsContextMenu_ButtonMenu[$eSettings]), $idContextMenu_ButtonMenu)                ;"Settings"
$idContext_Help = GUICtrlCreateMenuItem(GetStringFromResources($anArrayStringsContextMenu_ButtonMenu[$eHelp]), $idContextMenu_ButtonMenu)                        ;"Help"
GUICtrlCreateMenuItem("", $idContextMenu_ButtonMenu)
$idContext_About = GUICtrlCreateMenuItem(GetStringFromResources($anArrayStringsContextMenu_ButtonMenu[$eAbout]), $idContextMenu_ButtonMenu)                      ;"About"
#EndRegion;-----------------------------------------------------------------------------------------

$idButton_Clear = GUICtrlCreateButton("C", 65, 68, 66, 53)
GUICtrlSetTip(-1, GetStringFromResources($anArrayStringsMain[$eButtonClearTip]))                                                         ;"Clear All"
$idButton_Frames = GUICtrlCreateButton(" f ", 130, 68, 66, 53)                                                                           ;2x SPACE compensate for cutting off the italic letter "f"
GUICtrlSetFont(-1, 18, 400, 2, "Segoe UI")
GUICtrlSetTip(-1, GetStringFromResources($anArrayStringsMain[$eButtonFramesTipF]))                                                       ;"Frames"
$idButton_7 = GUICtrlCreateButton("7", 0, 120, 66, 53)
$idButton_8 = GUICtrlCreateButton("8", 65, 120, 66, 53)
$idButton_9 = GUICtrlCreateButton("9", 130, 120, 66, 53)
$idButton_4 = GUICtrlCreateButton("4", 0, 172, 66, 53)
$idButton_5 = GUICtrlCreateButton("5", 65, 172, 66, 53)
$idButton_6 = GUICtrlCreateButton("6", 130, 172, 66, 53)
$idButton_1 = GUICtrlCreateButton("1", 0, 224, 66, 53)
$idButton_2 = GUICtrlCreateButton("2", 65, 224, 66, 53)
$idButton_3 = GUICtrlCreateButton("3", 130, 224, 66, 53)
$idButton_Paste = GUICtrlCreateButton("", 0, 276, 66, 53)
GUICtrlSetTip(-1, GetStringFromResources($anArrayStringsMain[$eButtonPasteTip]))                                                         ;"Paste (Replace All)"
$idButton_0 = GUICtrlCreateButton("0", 65, 276, 66, 53)
$idButton_Copy = GUICtrlCreateButton("", 130, 276, 66, 53)
GUICtrlSetTip(-1, GetStringFromResources($anArrayStringsMain[$eButtonCopyTip]))                                                          ;"Copy All"
$idButton_Divide = GUICtrlCreateButton("", 195, 68, 66, 53)
$idButton_Multiply = GUICtrlCreateButton("", 195, 120, 66, 53)
$idButton_Subtract = GUICtrlCreateButton("", 195, 172, 66, 53)
$idButton_Addition = GUICtrlCreateButton("", 195, 224, 66, 53)
$idButton_EqualTo = GUICtrlCreateButton("", 195, 276, 66, 53)
;-------------------------------------------------------------------------for Button Blinking
Global $hButton_0 = ControlGetHandle($hFormMain, "", $idButton_0)
Global $hButton_1 = ControlGetHandle($hFormMain, "", $idButton_1)
Global $hButton_2 = ControlGetHandle($hFormMain, "", $idButton_2)
Global $hButton_3 = ControlGetHandle($hFormMain, "", $idButton_3)
Global $hButton_4 = ControlGetHandle($hFormMain, "", $idButton_4)
Global $hButton_5 = ControlGetHandle($hFormMain, "", $idButton_5)
Global $hButton_6 = ControlGetHandle($hFormMain, "", $idButton_6)
Global $hButton_7 = ControlGetHandle($hFormMain, "", $idButton_7)
Global $hButton_8 = ControlGetHandle($hFormMain, "", $idButton_8)
Global $hButton_9 = ControlGetHandle($hFormMain, "", $idButton_9)
;------------------------------------------------------------------------------Accelerators
$idDummy_Divide = GUICtrlCreateDummy()
$idDummy_Multiply = GUICtrlCreateDummy()
$idDummy_Subtract = GUICtrlCreateDummy()
$idDummy_Addition = GUICtrlCreateDummy()
$idDummy_EqualTo = GUICtrlCreateDummy()
$idDummy_Clear = GUICtrlCreateDummy()
$idDummy_Frames = GUICtrlCreateDummy()

Global $hButton_Divide = ControlGetHandle($hFormMain, "", $idButton_Divide)
Global $hButton_Multiply = ControlGetHandle($hFormMain, "", $idButton_Multiply)
Global $hButton_Subtract = ControlGetHandle($hFormMain, "", $idButton_Subtract)
Global $hButton_Addition = ControlGetHandle($hFormMain, "", $idButton_Addition)
Global $hButton_EqualTo = ControlGetHandle($hFormMain, "", $idButton_EqualTo)
Global $hButton_Clear = ControlGetHandle($hFormMain, "", $idButton_Clear)
Global $hButton_Frames = ControlGetHandle($hFormMain, "", $idButton_Frames)

$idDummy = GUICtrlCreateDummy()
Dim $aAcc[104][2] = [["{NUMPADDIV}", $idDummy_Divide], ["{NUMPADMULT}", $idDummy_Multiply], ["{NUMPADSUB}", $idDummy_Subtract], ["{NUMPADADD}", $idDummy_Addition], ["{ENTER}", $idDummy_EqualTo], ["{NUMPADDOT}", $idDummy_Clear], ["q", $idDummy], ["w", $idDummy], ["e", $idDummy], ["r", $idDummy], ["t", $idDummy], ["y", $idDummy], ["u", $idDummy], ["i", $idDummy], ["o", $idDummy], ["p", $idDummy], ["[", $idDummy], ["]", $idDummy], ["a", $idDummy], ["s", $idDummy], ["l", $idDummy], ["k", $idDummy], ["j", $idDummy], ["h", $idDummy], ["\", $idDummy], ["z", $idDummy], ["x", $idDummy], ["d", $idDummy], ["f", $idDummy_Frames], ["g", $idDummy], ["h", $idDummy], ["j", $idDummy], ["k", $idDummy], ["l", $idDummy], [";", $idDummy], ["'", $idDummy], ["\", $idDummy], ["z", $idDummy], ["x", $idDummy], ["c", $idDummy], ["v", $idDummy], ["b", $idDummy], ["n", $idDummy], ["m", $idDummy], [",", $idDummy], [".", $idDummy], ["/", $idDummy], ["+q", $idDummy], ["+w", $idDummy], ["+e", $idDummy], ["+r", $idDummy], ["+t", $idDummy], ["+y", $idDummy], ["+u", $idDummy], ["+i", $idDummy], ["+o", $idDummy], ["+p", $idDummy], ["+[", $idDummy], ["+]", $idDummy], ["+a", $idDummy], ["+s", $idDummy], ["+l", $idDummy], ["+k", $idDummy], ["+j", $idDummy], ["+h", $idDummy], ["+\", $idDummy], ["+z", $idDummy], ["+x", $idDummy], ["+d", $idDummy], ["+f", $idDummy], ["+g", $idDummy], ["+h", $idDummy], ["+j", $idDummy], ["+k", $idDummy], ["+l", $idDummy], ["+;", $idDummy], ["+'", $idDummy], ["+\", $idDummy], ["+z", $idDummy], ["+x", $idDummy], ["+c", $idDummy], ["+v", $idDummy], ["+b", $idDummy], ["+n", $idDummy], ["+m", $idDummy], ["+,", $idDummy], ["+.", $idDummy], ["+/", $idDummy], ["`", $idDummy], ["+`", $idDummy], ["+1", $idDummy], ["+2", $idDummy], ["+3", $idDummy], ["+4", $idDummy], ["+5", $idDummy], ["+6", $idDummy], ["+7", $idDummy], ["+8", $idDummy], ["+9", $idDummy], ["+0", $idDummy], ["-", $idDummy], ["+-", $idDummy], ["=", $idDummy], ["+=", $idDummy]]

$nResultatus = GUISetAccelerators($aAcc)

#Region	 ;---------------------Button skin--------------------------------------------
Global $ansArrayBtnImg[20][3] = [[$idButton_0, 200, 200], [$idButton_1, 200, 200], [$idButton_2, 200, 200], [$idButton_3, 200, 200], [$idButton_4, 200, 200], [$idButton_5, 200, 200], [$idButton_6, 200, 200], [$idButton_7, 200, 200], [$idButton_8, 200, 200], [$idButton_9, 200, 200], [$idButton_Clear, 201, 201], [$idButton_Frames, 201, 201], [$idButton_Menu, 202, 202], [$idButton_Paste, 203, 303], [$idButton_Copy, 204, 204], [$idButton_Divide, 205, 205], [$idButton_Multiply, 206, 206], [$idButton_Subtract, 207, 207], [$idButton_Addition, 208, 208], [$idButton_EqualTo, 209, 309]]

Global $ii = 1    ;BMP 2xx
Global $i_max = UBound($ansArrayBtnImg) - 1

If @OSVersion == "WIN_11" Then    ;Or WIN_12
	$ii = 2        ;BMP 3xx
EndIf

For $i = 0 To $i_max Step 1
	SkinForButtons()
Next

;-------------------------------------------------------------------------------------------Windows 11 Skin (method by Andy27)
If @OSVersion == "WIN_11" Then    ;Or WIN_12
	GUISetBkColor(0x4C4C4C, $hFormMain)
	GUICtrlSetBkColor($idInput, 0x4C4C4C)
	GUICtrlSetColor($idInput, 0xFFFFFF)
	$iSuccess = _WinAPI_DwmSetWindowAttribute($hFormMain, 35, 0x4C4C4C)        ;title bg
	If $iSuccess = 0 Then
		MsgBox(0, "Error", "Failed to set window title background")
		Exit
	EndIf
	$iSuccess = _WinAPI_DwmSetWindowAttribute($hFormMain, 36, 0xFFFFFF)        ;title text color
	If $iSuccess = 0 Then
		MsgBox(0, "Error", "Failed to set window title text color")
		Exit
	EndIf
EndIf
#EndRegion	 ;---------------------Button skin--------------------------------------------

If $bTrainingMode Then
	GUICtrlSetState($idButton_EqualTo, $GUI_DISABLE)
EndIf
;-----------------------------------------------------------------------------Tilde
$idLabel_Tilde = GUICtrlCreateLabel("~", 5, 6, 16, 49, $SS_CENTER)
GUICtrlSetFont(-1, 24, 400, 0, "Segoe UI")
If @OSVersion == "WIN_11" Then    ;Or WIN_12
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x4C4C4C)
Else
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
EndIf
GUICtrlSetState(-1, $GUI_HIDE)
;-------------------------------------
GUISetState(@SW_SHOW)

GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)

Global $hDLL = DllOpen("user32.dll")        ; for _IsPressed

GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

GUIRegisterMsg($WM_EXITMENULOOP, "WM_EXITMENULOOP")

$wProcHandle = DllCallbackRegister("_WindowProc", "ptr", "hwnd;uint;wparam;lparam")
$wProcOld = _WinAPI_SetWindowLong(GUICtrlGetHandle($idInput), $GWL_WNDPROC, DllCallbackGetPtr($wProcHandle))
#EndRegion ;------------END Koda GUI section-------------------------------------------


#Region;---------------START Koda GUI section--------------FormSettings----------------
$hFormSettings = GUICreate(GetStringFromResources($anArrayStringsSettings[$eFormSettingsTitle]), 380, 550, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU), -1, $hFormMain)             ;"Settings"
GUISetIcon(@ScriptFullPath, 99)
GUISetFont(10, 400, 0, "Segoe UI")
$hTab = GUICtrlCreateTab(10, 10, 361, 491)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
;---------------------------------------------------------------------General Tab
$idTabSheet_General = GUICtrlCreateTabItem(GetStringFromResources($anArayStringsSettingsTabGeneral[$eTabGeneralTitle]))                                                         ;"General"
GUICtrlSetState(-1, $GUI_SHOW)
$idGroup_FPS = GUICtrlCreateGroup(GetStringFromResources($anArayStringsSettingsTabGeneral[$eGroupFPS]), 20, 50, 340, 80)                                                        ;"Frame rate"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idLabel_FPS = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabGeneral[$eLabelFPS]), 40, 84, 205, 21, $SS_RIGHT)                                             ;"Frames per second:"
$idCombo_FPS = GUICtrlCreateCombo("", 260, 82, 80, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, Combo_FPSFullList(), GetStringFromResources($anArrayFPS[$nFPSMode][0]))
GUICtrlCreateGroup("", -99, -99, 1, 1)
$idGroup_Training = GUICtrlCreateGroup(GetStringFromResources($anArayStringsSettingsTabGeneral[$eGroupTraining]), 20, 150, 340, 130)                                            ;"Training Mode"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idCheckbox_Training = GUICtrlCreateCheckbox(GetStringFromResources($anArayStringsSettingsTabGeneral[$eCheckBoxTraining]), 40, 180, 300, 31, BitOR($GUI_SS_DEFAULT_CHECKBOX, $BS_MULTILINE))       ;"Lock arithmetic operator buttons"
$idLabel_Training = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabGeneral[$eLabelTraining]), 40, 220, 300, 41)                                                                ;"Enabling or disabling this mode does not change the logic of the program."
GUICtrlCreateGroup("", -99, -99, 1, 1)

If $bTrainingMode Then
	GUICtrlSetState($idCheckbox_Training, $GUI_CHECKED)
EndIf

;--------------------------------------------------------------------Separators Tab
$idTabSheet_Separator = GUICtrlCreateTabItem(GetStringFromResources($anArayStringsSettingsTabSeparator[$eTabSeparatorTitle]))                                  ;"Separators"

$idGroup_NonDropFrame = GUICtrlCreateGroup(GetStringFromResources($anArayStringsSettingsTabSeparator[$eGroupNonDrop]), 20, 50, 340, 121)                       ;"Non-Drop Timecode"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idLabel_NonDropFrame = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabSeparator[$eLabelNonDrop]), 40, 80, 300, 71)                        ;"There's nothing to change here. According to the SMPTE 12M standard, the only possible Non-Drop Timecode separator is a colon."
GUICtrlCreateGroup("", -99, -99, 1, 1)
$idGroup_DropFrame = GUICtrlCreateGroup(GetStringFromResources($anArayStringsSettingsTabSeparator[$eGroupDrop]), 20, 190, 340, 191)                            ;"Drop-Frame Timecode"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idCombo_DropFrame = GUICtrlCreateCombo("", 210, 220, 130, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, Combo_DropFrameFullList(), $asArrayDropSeparators[$nDropSeparatorMode][0])
GUICtrlSetFont(-1, 15, 400, 0, "Segoe UI")
$idLabel_DropFrame = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabSeparator[$eLabelDrop]), 40, 228, 160, 21, $SS_RIGHT)                  ;"Separators:"
$idLabel_DropFrame2 = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabSeparator[$eLabelDrop2]), 40, 270, 300, 91)                           ;"The SMTPE 12M standard allows four sets of separators for drop-frame timecode. Select a set of separators that matches your video editing program."
GUICtrlCreateGroup("", -99, -99, 1, 1)
$idLabel_Wikipedia = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabSeparator[$eLabelWikipedia]), 20, 390, 340, 21, $SS_CENTER)            ;"WikipediA: SMPTE timecode"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x0B6992)
GUICtrlSetCursor(-1, 0)

;--------------------------------------------------------------------$Tricks Tab
$idTabSheet_Tricks = GUICtrlCreateTabItem(GetStringFromResources($anArayStringsSettingsTabTricks[$eTabTricksTitle]))                                           ;"Tricks"
$idGroup_BadSeparator = GUICtrlCreateGroup(GetStringFromResources($anArayStringsSettingsTabTricks[$eGroupBadSeparator]), 20, 50, 340, 210)                     ;"Custom separators"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idCheckbox_BadSeparator = GUICtrlCreateCheckbox(GetStringFromResources($anArayStringsSettingsTabTricks[$eCheckboxBadSeparator]), 40, 80, 300, 31)             ;"Enable custom separators"
$idLabel_BadSeparator = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabTricks[$eLabelBadSeparator]), 40, 120, 300, 81)                     ;"All separators in the program will be replaced with the separators you select below. This may be useful to ensure compatibility with a non-standard program."
$idLabel_Bad_Hours = GUICtrlCreateLabel("00", 70, 212, 30, 32, $SS_CENTER)
GUICtrlSetFont(-1, 15, 400, 0, "Segoe UI")
$idLabel_Bad_Minutes = GUICtrlCreateLabel("00", 140, 212, 30, 32, $SS_CENTER)
GUICtrlSetFont(-1, 15, 400, 0, "Segoe UI")
$idLabel_Bad_Seconds = GUICtrlCreateLabel("00", 210, 212, 30, 32, $SS_CENTER)
GUICtrlSetFont(-1, 15, 400, 0, "Segoe UI")
$idLabel_Bad_Frames = GUICtrlCreateLabel("00", 280, 212, 30, 32, $SS_CENTER)
GUICtrlSetFont(-1, 15, 400, 0, "Segoe UI")
$idInput_Bad_1 = GUICtrlCreateInput("", 105, 210, 30, 36, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetLimit(-1, 1)
GUICtrlSetData(-1, $sBadSeparatorFirst)
GUICtrlSetFont(-1, 15, 400, 0, "Segoe UI")
$idInput_Bad_2 = GUICtrlCreateInput("", 175, 210, 30, 36, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetLimit(-1, 1)
GUICtrlSetData(-1, $sBadSeparatorSecond)
GUICtrlSetFont(-1, 15, 400, 0, "Segoe UI")
$idInput_Bad_3 = GUICtrlCreateInput("", 245, 210, 30, 36, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetLimit(-1, 1)
GUICtrlSetData(-1, $sBadSeparatorThird)
GUICtrlSetFont(-1, 15, 400, 0, "Segoe UI")
GUICtrlCreateGroup("", -99, -99, 1, 1)
If Not $bBadSeparatorMode Then
	GUICtrlSetState($idLabel_Bad_Hours, $GUI_DISABLE)
	GUICtrlSetState($idLabel_Bad_Minutes, $GUI_DISABLE)
	GUICtrlSetState($idLabel_Bad_Seconds, $GUI_DISABLE)
	GUICtrlSetState($idLabel_Bad_Frames, $GUI_DISABLE)
	GUICtrlSetState($idInput_Bad_1, $GUI_DISABLE)
	GUICtrlSetState($idInput_Bad_2, $GUI_DISABLE)
	GUICtrlSetState($idInput_Bad_3, $GUI_DISABLE)
Else
	GUICtrlSetState($idCheckbox_BadSeparator, $GUI_CHECKED)
	GUICtrlSetState($idLabel_NonDropFrame, $GUI_DISABLE)
	GUICtrlSetState($idCombo_DropFrame, $GUI_DISABLE)
	GUICtrlSetState($idLabel_DropFrame, $GUI_DISABLE)
	GUICtrlSetState($idLabel_DropFrame2, $GUI_DISABLE)
EndIf
;-----------------------------
$idGroup_HotKey = GUICtrlCreateGroup(GetStringFromResources($anArayStringsSettingsTabTricks[$eGroupHotKey]), 20, 280, 341, 201)                                ;"Hotkeys for Smart Paste"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idCheckbox_HotKey = GUICtrlCreateCheckbox(GetStringFromResources($anArayStringsSettingsTabTricks[$eCheckboxHotKey]), 40, 310, 90, 21)                         ;"Enable"
$hInput_HotKey = _GUICtrlHotkey_Create($hFormSettings, 140, 309, 200, 23)
_GUICtrlHotkey_SetHotkeyCode($hInput_HotKey, $iHotKeyCode)
ControlHide($hFormSettings, "", $hInput_HotKey)
$idLabel_HotKey = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabTricks[$eLabelHotKey]), 40, 350, 300, 111)                                ;"Select hotkeys to launch Smart Paste, which will clear timecode from the clipboard of separators and paste the remaining digits into the target program, simulating keyboard input."
GUICtrlCreateGroup("", -99, -99, 1, 1)

If Not $bHotKeyMode Then
	ControlDisable($hFormSettings, "", $hInput_HotKey)
Else
	GUICtrlSetState($idCheckbox_HotKey, $GUI_CHECKED)
EndIf

;-----------------------------------------------------------------------------About Tab
$idTabSheet_About = GUICtrlCreateTabItem(GetStringFromResources($anArayStringsSettingsTabAbout[$eTabAboutTitle]))                                             ;"About"
$Icon1 = GUICtrlCreateIcon(@ScriptFullPath, 99, 154, 68, 64, 64)
$idLabel_About_Name = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabAbout[$eLabelAboutName]), 34, 150, 310, 41, $SS_CENTER)              ;"tcCalculator"
GUICtrlSetFont(-1, 20, 700, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x4C4C4C)
$idLabel_About_Version = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabAbout[$eLabelAboutVersion]), 34, 191, 310, 21, $SS_CENTER)        ;"v.1.0.0.0"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idLabel_About_Copyright = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabAbout[$eLabelAboutCopyright]), 34, 212, 310, 21, $SS_CENTER)    ;"Copyright © 2024 NyBumBum"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idLabel_About_Site = GUICtrlCreateLabel("www.tccalculator.ru", 34, 233, 310, 21, $SS_CENTER)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x0B6992)
GUICtrlSetCursor(-1, 0)
$idLabel_About_GitHub = GUICtrlCreateLabel("www.github.com/nbb1967/tccalculator", 34, 254, 310, 21, $SS_CENTER)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x0B6992)
GUICtrlSetCursor(-1, 0)
$idLabel_About_Contact = GUICtrlCreateLabel("nybumbum@gmail.com", 34, 275, 310, 21, $SS_CENTER)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x0B6992)
GUICtrlSetCursor(-1, 0)
$idLabel_About_Comment = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabAbout[$eLabelAboutComment]), 34, 296, 310, 21, $SS_CENTER)        ;"Created with Autoit"
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idGroup_About_Notice = GUICtrlCreateGroup("", 34, 338, 310, 141)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
$idLabel__About_Notice = GUICtrlCreateLabel(GetStringFromResources($anArayStringsSettingsTabAbout[$eLabelAboutDisclaimer]), 54, 368, 270, 91)                 ;"This software is provided «AS IS» without warranty of any kind. This software is free for personal, non-commercial use."
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$idButton_Save = GUICtrlCreateButton(GetStringFromResources($anArrayStringsSettings[$eButtonSave]), 270, 510, 100, 31)                                        ;"Save"
#EndRegion ;---------------------------------------------------------------------------------------------------


If $bHotKeyMode And $iHotKeyCode <> 0 Then
	$sHotKey = _GUICtrlHotkey_GetHotkey($hInput_HotKey)
	_FixAccelHotKeyLayout()
	$iError = RegistrationHotkey($sHotKey)
	If $iError <> 0 Then
		PrintError($iError + 1)  ;Error 13
		$bHotKeyMode = 0
		GUICtrlSetState($idCheckbox_HotKey, $GUI_UNCHECKED)
		ControlDisable($hFormSettings, "", $hInput_HotKey)
		Switch $sArchitecture
			Case "X64"
				RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "HotKeyMode", "REG_DWORD", $bHotKeyMode)
			Case "X86"
				RegWrite("HKCU\Software\NyBumBum\tcCalculator", "HotKeyMode", "REG_DWORD", $bHotKeyMode)
		EndSwitch
	EndIf
EndIf
;---------------------------------------------------------------------------------------Disable ContextMenu
Global $apPTR_Bad_1[2]
$hInput_Bad_1 = GUICtrlGetHandle($idInput_Bad_1)

$hNoContextMenuInput_Bad_1 = DllCallbackRegister('_NoContextMenuInput_Bad_1', 'ptr', 'hwnd;uint;wparam;lparam')
$apPTR_Bad_1[1] = DllCallbackGetPtr($hNoContextMenuInput_Bad_1)
$apPTR_Bad_1[0] = _WinAPI_SetWindowLong($hInput_Bad_1, $GWL_WNDPROC, $apPTR_Bad_1[1])
;----------------------------
Global $apPTR_Bad_2[2]
$hInput_Bad_2 = GUICtrlGetHandle($idInput_Bad_2)

$hNoContextMenuInput_Bad_2 = DllCallbackRegister('_NoContextMenuInput_Bad_2', 'ptr', 'hwnd;uint;wparam;lparam')
$apPTR_Bad_2[1] = DllCallbackGetPtr($hNoContextMenuInput_Bad_2)
$apPTR_Bad_2[0] = _WinAPI_SetWindowLong($hInput_Bad_2, $GWL_WNDPROC, $apPTR_Bad_2[1])
;----------------------------
Global $apPTR_Bad_3[2]
$hInput_Bad_3 = GUICtrlGetHandle($idInput_Bad_3)

$hNoContextMenuInput_Bad_3 = DllCallbackRegister('_NoContextMenuInput_Bad_3', 'ptr', 'hwnd;uint;wparam;lparam')
$apPTR_Bad_3[1] = DllCallbackGetPtr($hNoContextMenuInput_Bad_3)
$apPTR_Bad_3[0] = _WinAPI_SetWindowLong($hInput_Bad_3, $GWL_WNDPROC, $apPTR_Bad_3[1])

;-----------------------------------------------------------------------------------------------------------

Local $bOnlyDigit                 ;for Button Paste (f-mode to tc-mode automatic switching)
;-----------------------------------------------------------------------------------------------------------
$iLastTab = 5                    ;To hiding UDF-created $hInput_HotKey from tabs

;--------------------------------------------------------------------------------------------------------------------Selection
Local $hInput = ControlGetHandle("", "", $idInput)
Local $hCtrlInKeyboardFocus

While 1
	$hCtrlInKeyboardFocus = ControlGetHandle($hFormMain, "", ControlGetFocus($hFormMain))
	If $hCtrlInKeyboardFocus = $hInput Then
		$aBeforeSel = _GUICtrlEdit_GetSel($idInput)
		$iDiffBeforeSel = Abs($aBeforeSel[1] - $aBeforeSel[0])
	EndIf
	;--------------------------------------------------------
	$aMsg = GUIGetMsg(1)
	Select        ;-----------------------------------------------------------Close Main
		Case $aMsg[0] = $GUI_EVENT_CLOSE And $aMsg[1] = $hFormMain
			ExitLoop
			;-----------------------------------------------------------------Restore Main
		Case $aMsg[0] = $GUI_EVENT_RESTORE And $aMsg[1] = $hFormMain
			GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)
			;---------------------------------------------------------------Digital Button
		Case $aMsg[0] = $idButton_0
			GUICtrlSetData($idInput, 0, Default)    ;optional:default - paste in position of cursor
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_1
			GUICtrlSetData($idInput, 1, Default)
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_2
			GUICtrlSetData($idInput, 2, Default)
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_3
			GUICtrlSetData($idInput, 3, Default)
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_4
			GUICtrlSetData($idInput, 4, Default)
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_5
			GUICtrlSetData($idInput, 5, Default)
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_6
			GUICtrlSetData($idInput, 6, Default)
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_7
			GUICtrlSetData($idInput, 7, Default)
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_8
			GUICtrlSetData($idInput, 8, Default)
			ControlFocus($hFormMain, "", $idInput)
		Case $aMsg[0] = $idButton_9
			GUICtrlSetData($idInput, 9, Default)
			ControlFocus($hFormMain, "", $idInput)
			;---------------------------------------------------------------------------------Copy
		Case $aMsg[0] = $idButton_Copy
			$sInputData = GUICtrlRead($idInput)
			ClipPut($sInputData)
			ControlFocus($hFormMain, "", $idInput)
			;---------------------------------------------------------------------------------Paste
		Case $aMsg[0] = $idButton_Paste
			If $nInputMode = 2 Then
				$bOnlyDigit = StringIsDigit(ClipGet())
				If Not $bOnlyDigit Then
					$nInputMode = 1
					GUICtrlSetData($idButton_Frames, " f ")
					GUICtrlSetTip($idButton_Frames, GetStringFromResources($anArrayStringsMain[$eButtonFramesTipF]))                        ;"Frames"
					GUICtrlSetLimit($idInput, 12)
				EndIf
			EndIf
			GUICtrlSetData($idInput, ClipGet())
			ControlFocus($hFormMain, "", $idInput)
			;----------------------------------------------------------------------------------Clear
		Case $aMsg[0] = $idButton_Clear
			$sResultTC = ""
			$iArgumentFirstFrame = 0
			$iArgumentSecondFrame = 0
			$iResultFrame = 0
			Switch $nInputMode
				Case 1
					GUICtrlSetData($idInput, "")
					$sTempTC = "00" & $sSeparatorFirst & "00" & $sSeparatorSecond & "00" & $sSeparatorThird & "00"
					GUICtrlSetData($idInput, $sTempTC)
					GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)
					If $nArithmeticOperation <> 0 Then
						If $bTrainingMode Then
							GUICtrlSetState($idButton_Addition, $GUI_ENABLE)
							GUICtrlSetState($idButton_Subtract, $GUI_ENABLE)
							GUICtrlSetState($idButton_Multiply, $GUI_ENABLE)
							GUICtrlSetState($idButton_Divide, $GUI_ENABLE)
							GUICtrlSetState($idButton_EqualTo, $GUI_DISABLE)
						EndIf
						$nArithmeticOperation = 0
					EndIf
				Case 2
					GUICtrlSetData($idInput, "")
					GUICtrlSetData($idInput, "0")
					GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)
					If $nArithmeticOperation <> 0 Then
						If $bTrainingMode Then
							GUICtrlSetState($idButton_Addition, $GUI_ENABLE)
							GUICtrlSetState($idButton_Subtract, $GUI_ENABLE)
							GUICtrlSetState($idButton_Multiply, $GUI_ENABLE)
							GUICtrlSetState($idButton_Divide, $GUI_ENABLE)
							GUICtrlSetState($idButton_EqualTo, $GUI_DISABLE)
						EndIf
						$nArithmeticOperation = 0
					EndIf
				Case 3
					$nInputMode = 1
					$nArithmeticOperation = 0
					GUICtrlSetData($idButton_Frames, " f ")
					GUICtrlSetTip($idButton_Frames, GetStringFromResources($anArrayStringsMain[$eButtonFramesTipF]))                        ;"Frames"
					GUICtrlSetData($idInput, "")
					GUICtrlSetStyle($idInput, $ES_CENTER)
					GUICtrlSetLimit($idInput, 12)
					$sTempTC = "00" & $sSeparatorFirst & "00" & $sSeparatorSecond & "00" & $sSeparatorThird & "00"
					GUICtrlSetData($idInput, $sTempTC)
					GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)

					GUICtrlSetState($idButton_Frames, $GUI_ENABLE)
					If $bTrainingMode Then
						GUICtrlSetState($idButton_Addition, $GUI_ENABLE)
						GUICtrlSetState($idButton_Subtract, $GUI_ENABLE)
						GUICtrlSetState($idButton_Multiply, $GUI_ENABLE)
						GUICtrlSetState($idButton_Divide, $GUI_ENABLE)
						GUICtrlSetState($idButton_EqualTo, $GUI_DISABLE)
					EndIf
			EndSwitch
			ControlFocus($hFormMain, "", $idInput)
			;----------------------------------------------------------------------------------Frames
		Case $aMsg[0] = $idButton_Frames
			Switch $nInputMode
				Case 1
					$iError = CheckTC()
					If $iError <> 0 Then
						PrintError($iError)
						ContinueLoop
					EndIf
					ConversionTimeCodeToFrames()
					$nInputMode = 2
					GUICtrlSetLimit($idInput, 7)
					GUICtrlSetData($idInput, $iTotalNumberFrames)
					GUICtrlSetData($idButton_Frames, "tc")
					GUICtrlSetTip($idButton_Frames, GetStringFromResources($anArrayStringsMain[$eButtonFramesTipTC]))                        ;"Timecode"
					GUICtrlSetStyle($idInput, $ES_RIGHT)
					ControlFocus($hFormMain, "", $idInput)
					GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)
				Case 2
					$iError = CheckFrames()
					If $iError <> 0 Then
						PrintError($iError)
						ContinueLoop
					EndIf
					ConversionFramesToTimeCode()
					$nInputMode = 1
					GUICtrlSetLimit($idInput, 12)
					$sTempTC = StringFormat("%02d", $iHours) & $sSeparatorFirst & StringFormat("%02d", $iMinutes) & $sSeparatorSecond & StringFormat("%02d", $iSeconds) & $sSeparatorThird & StringFormat("%02d", $iFrames)
					GUICtrlSetData($idInput, $sTempTC)
					GUICtrlSetData($idButton_Frames, " f ")
					GUICtrlSetTip($idButton_Frames, GetStringFromResources($anArrayStringsMain[$eButtonFramesTipF]))                         ;"Frames"
					GUICtrlSetStyle($idInput, $ES_CENTER)
					ControlFocus($hFormMain, "", $idInput)
					GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)
				Case 3
					ContinueLoop
			EndSwitch
			;----------------------------------------------------------------------------------------Menu
		Case $aMsg[0] = $idButton_Menu
			$iDiff = TimerDiff($hTimer)
			If $iDiff < 250 Then
				ControlFocus($hFormMain, "", $idInput)
				ContinueLoop
			Else
				ShowMenu($hFormMain, $aMsg[0], $idContextMenu_ButtonMenu)
			EndIf

		Case $aMsg[0] = $idContext_AlwaysOnTop
			If BitAND(GUICtrlRead($idContext_AlwaysOnTop), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($idContext_AlwaysOnTop, $GUI_UNCHECKED)
				WinSetOnTop($hFormMain, "", 0)
				ControlFocus($hFormMain, "", $idInput)
			Else
				GUICtrlSetState($idContext_AlwaysOnTop, $GUI_CHECKED)
				WinSetOnTop($hFormMain, "", 1)
				ControlFocus($hFormMain, "", $idInput)
			EndIf

		Case $aMsg[0] = $idContext_Settings
			GUISetState(@SW_SHOW, $hFormSettings)
			GUICtrlSetState($idTabSheet_General, $GUI_SHOW)
			GUISetState(@SW_DISABLE, $hFormMain)
		Case $aMsg[0] = $idContext_About
			GUISetState(@SW_SHOW, $hFormSettings)
			GUICtrlSetState($idTabSheet_About, $GUI_SHOW)
			GUISetState(@SW_DISABLE, $hFormMain)
		Case $aMsg[0] = $idContext_Help
			Switch @OSLang
				Case "0419"
					ShellExecute(@ScriptDir & "\help\ru\tcCalculator_ru.pdf")
				Case Else
					ShellExecute(@ScriptDir & "\help\en\tcCalculator_en.pdf")
			EndSwitch
			;-----------------------------------------------------------Addition, Subtract, Multiply, Divide
		Case $aMsg[0] = $idButton_Addition Or $aMsg[0] = $idButton_Subtract Or $aMsg[0] = $idButton_Multiply Or $aMsg[0] = $idButton_Divide
			GUICtrlSetState($idLabel_Tilde, $GUI_HIDE)
			If $nArithmeticOperation <> 0 Then
				ContinueLoop
			EndIf
			Switch $nInputMode
				Case 1
					$iError = CheckTC()
					If $iError <> 0 Then
						PrintError($iError)
						ContinueLoop
					EndIf
					ConversionTimeCodeToFrames()
				Case 2
					$iError = CheckFrames()
					If $iError <> 0 Then
						PrintError($iError)
						ContinueLoop
					EndIf
			EndSwitch
			$iArgumentFirstFrame = $iTotalNumberFrames
			If $bTrainingMode Then
				GUICtrlSetState($idButton_EqualTo, $GUI_ENABLE)
				GUICtrlSetState($idButton_Addition, $GUI_DISABLE)
				GUICtrlSetState($idButton_Subtract, $GUI_DISABLE)
				GUICtrlSetState($idButton_Multiply, $GUI_DISABLE)
				GUICtrlSetState($idButton_Divide, $GUI_DISABLE)
			EndIf
			Switch $aMsg[0]
				Case $idButton_Addition
					$nArithmeticOperation = 4
					Switch $nInputMode
						Case 1
							$sTempTC = "00" & $sSeparatorFirst & "00" & $sSeparatorSecond & "00" & $sSeparatorThird & "00"
							GUICtrlSetData($idInput, $sTempTC)
						Case 2
							GUICtrlSetData($idInput, 0)
					EndSwitch
				Case $idButton_Subtract
					$nArithmeticOperation = 3
					Switch $nInputMode
						Case 1
							$sTempTC = "00" & $sSeparatorFirst & "00" & $sSeparatorSecond & "00" & $sSeparatorThird & "00"
							GUICtrlSetData($idInput, $sTempTC)
						Case 2
							GUICtrlSetData($idInput, 0)
					EndSwitch
				Case $idButton_Multiply
					$nArithmeticOperation = 2
					$nInputMode = 3
					GUICtrlSetLimit($idInput, 2)
					GUICtrlSetData($idButton_Frames, "")
					GUICtrlSetStyle($idInput, $ES_RIGHT)
					If $bTrainingMode Then
						GUICtrlSetState($idButton_Frames, $GUI_DISABLE)
					EndIf
					GUICtrlSetData($idInput, 0)
				Case $idButton_Divide
					$nArithmeticOperation = 1
					$nInputMode = 3
					GUICtrlSetLimit($idInput, 2)
					GUICtrlSetData($idButton_Frames, "")
					GUICtrlSetStyle($idInput, $ES_RIGHT)
					If $bTrainingMode Then
						GUICtrlSetState($idButton_Frames, $GUI_DISABLE)
					EndIf
					GUICtrlSetData($idInput, 0)
			EndSwitch
			ControlFocus($hFormMain, "", $idInput)
			GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)
			;---------------------------------------------------------------------------------------EqualTo
		Case $aMsg[0] = $idButton_EqualTo
			If $nArithmeticOperation = 0 Then
				ContinueLoop
			EndIf
			Switch $nInputMode
				Case 1
					$iError = CheckTC()
					If $iError <> 0 Then
						PrintError($iError)
						ContinueLoop
					EndIf
					ConversionTimeCodeToFrames()
				Case 2
					$iError = CheckFrames()
					If $iError <> 0 Then
						PrintError($iError)
						ContinueLoop
					EndIf
				Case 3
					$iError = CheckInteger()
					If $iError <> 0 Then
						PrintError($iError)
						ContinueLoop
					EndIf
			EndSwitch

			$iArgumentSecondFrame = $iTotalNumberFrames
			Switch $nArithmeticOperation
				Case 1
					$iResultFrame = Int($iArgumentFirstFrame / $iArgumentSecondFrame)
					If Mod($iArgumentFirstFrame, $iArgumentSecondFrame) <> 0 Then
						GUICtrlSetState($idLabel_Tilde, $GUI_SHOW) ;----------------->>>   Tilde
					EndIf
				Case 2
					$iResultFrame = $iArgumentFirstFrame * $iArgumentSecondFrame
				Case 3
					If Number($iArgumentFirstFrame) < Number($iArgumentSecondFrame) Then
						$iError = 8
						PrintError($iError)
						$iArgumentSecondFrame = 0
						ContinueLoop
					Else
						$iResultFrame = $iArgumentFirstFrame - $iArgumentSecondFrame
					EndIf
				Case 4
					$iResultFrame = $iArgumentFirstFrame + $iArgumentSecondFrame
			EndSwitch
			$iError = CheckFramesMax($iResultFrame)
			If $iError <> 0 Then
				PrintError($iError)
				$iArgumentSecondFrame = 0
				ContinueLoop
			EndIf
			ConversionFramesToTimeCode()
			If $bTrainingMode And $nInputMode = 3 Then
				GUICtrlSetState($idButton_Frames, $GUI_ENABLE)
			EndIf
			If $nInputMode <> 1 Then
				$nInputMode = 1                            ; It's a Timecode calculator!
				GUICtrlSetLimit($idInput, 12)
				GUICtrlSetData($idButton_Frames, " f ")
				GUICtrlSetTip($idButton_Frames, GetStringFromResources($anArrayStringsMain[$eButtonFramesTipF]))                            ;"Frames"
				GUICtrlSetStyle($idInput, $ES_CENTER)
			EndIf
			$sResultTC = StringFormat("%02d", $iHours) & $sSeparatorFirst & StringFormat("%02d", $iMinutes) & $sSeparatorSecond & StringFormat("%02d", $iSeconds) & $sSeparatorThird & StringFormat("%02d", $iFrames)
			GUICtrlSetData($idInput, $sResultTC)
			$iArgumentFirstFrame = 0
			$iArgumentSecondFrame = 0
			If $bTrainingMode Then
				GUICtrlSetState($idButton_EqualTo, $GUI_DISABLE)
				GUICtrlSetState($idButton_Addition, $GUI_ENABLE)
				GUICtrlSetState($idButton_Subtract, $GUI_ENABLE)
				GUICtrlSetState($idButton_Multiply, $GUI_ENABLE)
				GUICtrlSetState($idButton_Divide, $GUI_ENABLE)
			EndIf
			$nArithmeticOperation = 0

			ControlFocus($hFormMain, "", $idInput)
			GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)

			;------------------------------------------------------------------------Close Settings
		Case $aMsg[0] = $GUI_EVENT_CLOSE And $aMsg[1] = $hFormSettings
			GUISetState(@SW_HIDE, $hFormSettings)
			GUISetState(@SW_ENABLE, $hFormMain)
			WinActivate($hFormMain)
			CancelUnsavedChanges()                        ; CLOSE = CANCEL
			$iLastTab = 5
			ControlHide($hFormSettings, "", $hInput_HotKey)
			ControlFocus($hFormMain, "", $idInput)
			GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)
			;---------------------------------------------------------------------------------Links
		Case $aMsg[0] = $idLabel_Wikipedia
			ShellExecute("https://en.wikipedia.org/wiki/SMPTE_timecode")
		Case $aMsg[0] = $idLabel_About_Site
			ShellExecute("https://tccalculator.ru")
		Case $aMsg[0] = $idLabel_About_GitHub
			ShellExecute("https://github.com/nbb1967/tccalculator")
		Case $aMsg[0] = $idLabel_About_Contact
			ShellExecute("mailto:nybumbum@gmail.com?subject=tcCalculator")
			;------------------------------------------------------------------Checkbox BadSeparator
		Case $aMsg[0] = $idCheckbox_BadSeparator
			If GUICtrlRead($idCheckbox_BadSeparator) = $GUI_CHECKED Then
				GUICtrlSetState($idLabel_Bad_Hours, $GUI_ENABLE)
				GUICtrlSetState($idLabel_Bad_Minutes, $GUI_ENABLE)
				GUICtrlSetState($idLabel_Bad_Seconds, $GUI_ENABLE)
				GUICtrlSetState($idLabel_Bad_Frames, $GUI_ENABLE)
				GUICtrlSetState($idInput_Bad_1, $GUI_ENABLE)
				GUICtrlSetState($idInput_Bad_2, $GUI_ENABLE)
				GUICtrlSetState($idInput_Bad_3, $GUI_ENABLE)
				GUICtrlSetState($idLabel_NonDropFrame, $GUI_DISABLE)
				GUICtrlSetState($idCombo_DropFrame, $GUI_DISABLE)
				GUICtrlSetState($idLabel_DropFrame, $GUI_DISABLE)
				GUICtrlSetState($idLabel_DropFrame2, $GUI_DISABLE)
			Else
				GUICtrlSetState($idLabel_Bad_Hours, $GUI_DISABLE)
				GUICtrlSetState($idLabel_Bad_Minutes, $GUI_DISABLE)
				GUICtrlSetState($idLabel_Bad_Seconds, $GUI_DISABLE)
				GUICtrlSetState($idLabel_Bad_Frames, $GUI_DISABLE)
				GUICtrlSetState($idInput_Bad_1, $GUI_DISABLE)
				GUICtrlSetState($idInput_Bad_2, $GUI_DISABLE)
				GUICtrlSetState($idInput_Bad_3, $GUI_DISABLE)
				GUICtrlSetState($idLabel_NonDropFrame, $GUI_ENABLE)
				GUICtrlSetState($idCombo_DropFrame, $GUI_ENABLE)
				GUICtrlSetState($idLabel_DropFrame, $GUI_ENABLE)
				GUICtrlSetState($idLabel_DropFrame2, $GUI_ENABLE)
			EndIf
			;-----------------------------------------------------------------------Checkbox HotKey
		Case $aMsg[0] = $idCheckbox_HotKey
			If GUICtrlRead($idCheckbox_HotKey) = $GUI_CHECKED Then
				ControlEnable($hFormSettings, "", $hInput_HotKey)
			Else
				ControlDisable($hFormSettings, "", $hInput_HotKey)
			EndIf
			;----------------------------------------------------------------Tab (for _GUICtrlHotkey_Create)
		Case $aMsg[0] = $hTab
			$iCurrTab = GUICtrlRead($hTab)
			If $iCurrTab <> $iLastTab Then
				ConsoleWrite($iCurrTab & @CRLF)
				Switch $iCurrTab
					Case 0
						ControlHide($hFormSettings, "", $hInput_HotKey)
					Case 1
						ControlHide($hFormSettings, "", $hInput_HotKey)
					Case 2
						ControlShow($hFormSettings, "", $hInput_HotKey)
					Case 3
						ControlHide($hFormSettings, "", $hInput_HotKey)
				EndSwitch
				$iLastTab = $iCurrTab
			EndIf
			;------------------------------------------------------------------------------Save
		Case $aMsg[0] = $idButton_Save
			$iError = SetRegistry()
			If $iError <> 0 Then
				PrintError($iError)
				ContinueLoop
			EndIf
			$iFPS = $anArrayFPS[$nFPSMode][1]
			$bDropFrameMode = $anArrayFPS[$nFPSMode][2]
			$iDropPerMinute = $anArrayFPS[$nFPSMode][3]
			ChoosingSeparators()
			$nFontSize = CalculateFontSize()
			If $nArithmeticOperation = 0 Then
				$sTempTC = StringRegExpReplace(GUICtrlRead($idInput), "[^0-9]", "")
				GUICtrlSetFont($idInput, $nFontSize, 400, 0, "Segoe UI")
				GUICtrlSetData($idInput, $sTempTC)
			Else
				$sResultTC = ""
				$iArgumentFirstFrame = 0
				$iArgumentSecondFrame = 0
				$nArithmeticOperation = 0
				$iResultFrame = 0

				$nInputMode = 1

				GUICtrlSetData($idButton_Frames, " f ")
				GUICtrlSetTip($idButton_Frames, GetStringFromResources($anArrayStringsMain[$eButtonFramesTipF]))                            ;"Frames"
				GUICtrlSetData($idInput, "")
				GUICtrlSetLimit($idInput, 12)
				GUICtrlSetStyle($idInput, $ES_CENTER)
				GUICtrlSetFont($idInput, $nFontSize, 400, 0, "Segoe UI")
				$sTempTC = "00" & $sSeparatorFirst & "00" & $sSeparatorSecond & "00" & $sSeparatorThird & "00"
				GUICtrlSetData($idInput, $sTempTC)

				GUICtrlSetState($idButton_Frames, $GUI_ENABLE)
				If $bTrainingMode Then
					GUICtrlSetState($idButton_Addition, $GUI_ENABLE)
					GUICtrlSetState($idButton_Subtract, $GUI_ENABLE)
					GUICtrlSetState($idButton_Multiply, $GUI_ENABLE)
					GUICtrlSetState($idButton_Divide, $GUI_ENABLE)
					GUICtrlSetState($idButton_EqualTo, $GUI_DISABLE)
				EndIf
			EndIf

			GUISetState(@SW_HIDE, $hFormSettings)
			GUISetState(@SW_ENABLE, $hFormMain)
			WinActivate($hFormMain)
			WinSetTitle($hFormMain, "", GetStringFromResources($anArrayStringsMain[$eFormMainTitle]) & " " & GetStringFromResources($anArrayFPS[$nFPSMode][0]))

			If $bTrainingMode Then
				Switch $nArithmeticOperation
					Case 0
						GUICtrlSetState($idButton_EqualTo, $GUI_DISABLE)
					Case 1, 2, 3, 4
						GUICtrlSetState($idButton_Addition, $GUI_DISABLE)
						GUICtrlSetState($idButton_Subtract, $GUI_DISABLE)
						GUICtrlSetState($idButton_Multiply, $GUI_DISABLE)
						GUICtrlSetState($idButton_Divide, $GUI_DISABLE)
				EndSwitch
			Else
				GUICtrlSetState($idButton_EqualTo, $GUI_ENABLE)
				GUICtrlSetState($idButton_Addition, $GUI_ENABLE)
				GUICtrlSetState($idButton_Subtract, $GUI_ENABLE)
				GUICtrlSetState($idButton_Multiply, $GUI_ENABLE)
				GUICtrlSetState($idButton_Divide, $GUI_ENABLE)
			EndIf

			$iLastTab = 5
			ControlHide($hFormSettings, "", $hInput_HotKey)
			ControlFocus($hFormMain, "", $idInput)
			GUICtrlSendMsg($idInput, $EM_SETSEL, -1, -1)
			;-------------------------------------------------------------------------------------Accelerators
		Case $aMsg[0] = $idDummy_Divide And $aMsg[1] = $hFormMain
			If BitAND(GUICtrlGetState($idButton_Divide), $GUI_DISABLE) = $GUI_DISABLE Then
				ContinueLoop
			Else
				_SendMessage($hButton_Divide, $BM_SETSTATE, True)
				Sleep(5)
				_SendMessage($hButton_Divide, $BM_CLICK, 0, 0)
				_SendMessage($hButton_Divide, $BM_SETSTATE, False)
			EndIf
		Case $aMsg[0] = $idDummy_Multiply And $aMsg[1] = $hFormMain
			If BitAND(GUICtrlGetState($idButton_Multiply), $GUI_DISABLE) = $GUI_DISABLE Then
				ContinueLoop
			Else
				_SendMessage($hButton_Multiply, $BM_SETSTATE, True)
				Sleep(5)
				_SendMessage($hButton_Multiply, $BM_CLICK, 0, 0)
				_SendMessage($hButton_Multiply, $BM_SETSTATE, False)
			EndIf
		Case $aMsg[0] = $idDummy_Subtract And $aMsg[1] = $hFormMain
			If BitAND(GUICtrlGetState($idButton_Subtract), $GUI_DISABLE) = $GUI_DISABLE Then
				ContinueLoop
			Else
				_SendMessage($hButton_Subtract, $BM_SETSTATE, True)
				Sleep(5)
				_SendMessage($hButton_Subtract, $BM_CLICK, 0, 0)
				_SendMessage($hButton_Subtract, $BM_SETSTATE, False)
			EndIf
		Case $aMsg[0] = $idDummy_Addition And $aMsg[1] = $hFormMain
			If BitAND(GUICtrlGetState($idButton_Addition), $GUI_DISABLE) = $GUI_DISABLE Then
				ContinueLoop
			Else
				_SendMessage($hButton_Addition, $BM_SETSTATE, True)
				Sleep(5)
				_SendMessage($hButton_Addition, $BM_CLICK, 0, 0)
				_SendMessage($hButton_Addition, $BM_SETSTATE, False)
			EndIf
		Case $aMsg[0] = $idDummy_EqualTo And $aMsg[1] = $hFormMain
			If BitAND(GUICtrlGetState($idButton_EqualTo), $GUI_DISABLE) = $GUI_DISABLE Then
				ContinueLoop
			Else
				_SendMessage($hButton_EqualTo, $BM_SETSTATE, True)
				Sleep(5)
				_SendMessage($hButton_EqualTo, $BM_CLICK, 0, 0)
				_SendMessage($hButton_EqualTo, $BM_SETSTATE, False)
			EndIf
		Case $aMsg[0] = $idDummy_Clear And $aMsg[1] = $hFormMain
			_SendMessage($hButton_Clear, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_Clear, $BM_CLICK, 0, 0)
			_SendMessage($hButton_Clear, $BM_SETSTATE, False)
		Case $aMsg[0] = $idDummy_Frames And $aMsg[1] = $hFormMain
			Switch $nInputMode
				Case 1, 2
					_SendMessage($hButton_Frames, $BM_SETSTATE, True)
					Sleep(5)
					_SendMessage($hButton_Frames, $BM_CLICK, 0, 0)
					_SendMessage($hButton_Frames, $BM_SETSTATE, False)
			EndSwitch

	EndSelect
	Sleep(10)
WEnd

HotKeySet($sHotKey)
_GUICtrlHotkey_Delete($hInput_HotKey)
GUIDelete($hFormMain)
_WinAPI_SetWindowLong($hInput_Bad_1, $GWL_WNDPROC, $apPTR_Bad_1[0])
_WinAPI_SetWindowLong($hInput_Bad_2, $GWL_WNDPROC, $apPTR_Bad_2[0])
_WinAPI_SetWindowLong($hInput_Bad_3, $GWL_WNDPROC, $apPTR_Bad_3[0])
DllCallbackFree($hNoContextMenuInput_Bad_1)
DllCallbackFree($hNoContextMenuInput_Bad_2)
DllCallbackFree($hNoContextMenuInput_Bad_3)
DllCallbackFree($wProcHandle)
GUIRegisterMsg($WM_COMMAND, "")
GUIRegisterMsg($WM_EXITMENULOOP, "")
DllClose($hDLL)
GUIDelete()

Exit

;==============================================================================================================

Func ChoosingSeparators()
	If $bBadSeparatorMode Then
		$sSeparatorFirst = $sBadSeparatorFirst
		$sSeparatorSecond = $sBadSeparatorSecond
		$sSeparatorThird = $sBadSeparatorThird
	Else
		If $bDropFrameMode Then
			$sSeparatorFirst = $asArrayDropSeparators[$nDropSeparatorMode][1]
			$sSeparatorSecond = $asArrayDropSeparators[$nDropSeparatorMode][2]
			$sSeparatorThird = $asArrayDropSeparators[$nDropSeparatorMode][3]
		Else
			$sSeparatorFirst = $asArrayNonDropSeparators[0][1]
			$sSeparatorSecond = $asArrayNonDropSeparators[0][2]
			$sSeparatorThird = $asArrayNonDropSeparators[0][3]
		EndIf
	EndIf
EndFunc   ;==>ChoosingSeparators
;-----------------------------------------------------------------------------------------
Func CancelUnsavedChanges()
	GetRegistry()

	WinSetTitle($hFormMain, "", GetStringFromResources($anArrayStringsMain[$eFormMainTitle]) & " " & GetStringFromResources($anArrayFPS[$nFPSMode][0]))
	GUICtrlSendMsg($idCombo_FPS, $CB_SETCURSEL, $nFPSMode, 0)
	;--------------------
	If $bTrainingMode Then
		GUICtrlSetState($idCheckbox_Training, $GUI_CHECKED)
	Else
		GUICtrlSetState($idCheckbox_Training, $GUI_UNCHECKED)
	EndIf
	;--------------------
	GUICtrlSendMsg($idCombo_DropFrame, $CB_SETCURSEL, $nDropSeparatorMode, 0)
	;--------------------
	If $bBadSeparatorMode Then
		GUICtrlSetState($idCheckbox_BadSeparator, $GUI_CHECKED)
		GUICtrlSetState($idLabel_Bad_Hours, $GUI_ENABLE)
		GUICtrlSetState($idLabel_Bad_Minutes, $GUI_ENABLE)
		GUICtrlSetState($idLabel_Bad_Seconds, $GUI_ENABLE)
		GUICtrlSetState($idLabel_Bad_Frames, $GUI_ENABLE)
		GUICtrlSetState($idInput_Bad_1, $GUI_ENABLE)
		GUICtrlSetState($idInput_Bad_2, $GUI_ENABLE)
		GUICtrlSetState($idInput_Bad_3, $GUI_ENABLE)
		GUICtrlSetState($idLabel_NonDropFrame, $GUI_DISABLE)
		GUICtrlSetState($idCombo_DropFrame, $GUI_DISABLE)
		GUICtrlSetState($idLabel_DropFrame, $GUI_DISABLE)
		GUICtrlSetState($idLabel_DropFrame2, $GUI_DISABLE)
	Else
		GUICtrlSetState($idCheckbox_BadSeparator, $GUI_UNCHECKED)
		GUICtrlSetState($idLabel_Bad_Hours, $GUI_DISABLE)
		GUICtrlSetState($idLabel_Bad_Minutes, $GUI_DISABLE)
		GUICtrlSetState($idLabel_Bad_Seconds, $GUI_DISABLE)
		GUICtrlSetState($idLabel_Bad_Frames, $GUI_DISABLE)
		GUICtrlSetState($idInput_Bad_1, $GUI_DISABLE)
		GUICtrlSetState($idInput_Bad_2, $GUI_DISABLE)
		GUICtrlSetState($idInput_Bad_3, $GUI_DISABLE)
		GUICtrlSetState($idLabel_NonDropFrame, $GUI_ENABLE)
		GUICtrlSetState($idCombo_DropFrame, $GUI_ENABLE)
		GUICtrlSetState($idLabel_DropFrame, $GUI_ENABLE)
		GUICtrlSetState($idLabel_DropFrame2, $GUI_ENABLE)
	EndIf
	;-------------------
	GUICtrlSetData($idInput_Bad_1, $sBadSeparatorFirst)
	GUICtrlSetData($idInput_Bad_2, $sBadSeparatorSecond)
	GUICtrlSetData($idInput_Bad_3, $sBadSeparatorThird)
	;-------------------
	If $bHotKeyMode Then
		GUICtrlSetState($idCheckbox_HotKey, $GUI_CHECKED)
		ControlEnable($hFormSettings, "", $hInput_HotKey)
	Else
		GUICtrlSetState($idCheckbox_HotKey, $GUI_UNCHECKED)
		ControlDisable($hFormSettings, "", $hInput_HotKey)
	EndIf
	;-------------------
	_GUICtrlHotkey_SetHotkeyCode($hInput_HotKey, $iHotKeyCode)
EndFunc   ;==>CancelUnsavedChanges
;------------------------------------------------------------------------------------------
Func CalculateFontSize()
	Local $sText = "00" & $sSeparatorFirst & "00" & $sSeparatorSecond & "00" & $sSeparatorThird & "00" & "89" ; 8 - padding (1/2 character width) on the left and right, 9 - required free space for text input
	Local $iWidthInput = 261    ; Width Input
	Local $sFont = "Segoe UI"
	$iWeight = 400
	$iAttrib = 0

	For $iSize = 20 To 35 Step 0.5
		$aSize = _StringSize($sText, $iSize, $iWeight, $iAttrib, $sFont)
		If $aSize[2] > $iWidthInput Then
			$iSize -= 0.5
			ExitLoop
		EndIf
	Next
	Return $iSize
EndFunc   ;==>CalculateFontSize
;-----------------------------------------------------------------------------------------
Func Combo_FPSFullList()
	Local $sList = ""
	Local $nMaxEntry = UBound($anArrayFPS) - 1
	For $i = 0 To $nMaxEntry
		$sList &= GetStringFromResources($anArrayFPS[$i][0]) & '|'
	Next
	$sList = StringTrimRight($sList, 1)
	Return $sList
EndFunc   ;==>Combo_FPSFullList
;-----------------------------------------------------------------------------------------
Func Combo_DropFrameFullList()
	Local $sList = ""
	Local $nMaxEntry = UBound($asArrayDropSeparators) - 1
	For $i = 0 To $nMaxEntry
		$sList &= $asArrayDropSeparators[$i][0] & '|'
	Next
	$sList = StringTrimRight($sList, 1)
	Return $sList
EndFunc   ;==>Combo_DropFrameFullList
;------------------------------------------------------------------------------------------
Func RegistrationHotkey($sHK)
	Local $bSuccess = HotKeySet($sHK, "SmartPaste")
	If Not $bSuccess Then
		Return 11
	EndIf
	Return 0
EndFunc   ;==>RegistrationHotkey

Func SmartPaste()
	While _IsPressed("10") Or _IsPressed("11") Or _IsPressed("12")        ; ©CreatoR (updown Shift,Ctrl,Alt)
		Sleep(10)
	WEnd

	Local $iOnlyNumbers = StringRegExpReplace(ClipGet(), "[^\d]", "\1")
	HotKeySet($sHotKey)    ;deregistration
	Send($iOnlyNumbers)
	HotKeySet($sHotKey, "SmartPaste")
EndFunc   ;==>SmartPaste

#Region	;--------------------Set Registry------------------------------------------------------
Func SetRegistry()
	;--------------------------------------------read in tmp
	Local $tmp_nFPSMode, $tmp_bTrainingMode, $tmp_nDropSeparatorMode, $tmp_bBadSeparatorMode, $tmp_sBadSeparatorFirst, $tmp_sBadSeparatorSecond, $tmp_sBadSeparatorThird, $tmp_bHotKeyMode, $tmp_iHotKeyCode, $tmp_sHotKey, $iErr

	$tmp_nFPSMode = GUICtrlSendMsg($idCombo_FPS, $CB_GETCURSEL, 0, 0)

	If BitAND(GUICtrlRead($idCheckbox_Training), $GUI_CHECKED) = $GUI_CHECKED Then
		$tmp_bTrainingMode = 1
	Else
		$tmp_bTrainingMode = 0
	EndIf

	$tmp_nDropSeparatorMode = GUICtrlSendMsg($idCombo_DropFrame, $CB_GETCURSEL, 0, 0)

	If BitAND(GUICtrlRead($idCheckbox_BadSeparator), $GUI_CHECKED) = $GUI_CHECKED Then
		$tmp_bBadSeparatorMode = 1
	Else
		$tmp_bBadSeparatorMode = 0
	EndIf

	If $tmp_bBadSeparatorMode Then
		$tmp_sBadSeparatorFirst = GUICtrlRead($idInput_Bad_1)
		$tmp_sBadSeparatorSecond = GUICtrlRead($idInput_Bad_2)
		$tmp_sBadSeparatorThird = GUICtrlRead($idInput_Bad_3)
	EndIf

	If BitAND(GUICtrlRead($idCheckbox_HotKey), $GUI_CHECKED) = $GUI_CHECKED Then
		$tmp_bHotKeyMode = 1
	Else
		$tmp_bHotKeyMode = 0
	EndIf

	$tmp_iHotKeyCode = _GUICtrlHotkey_GetHotkeyCode($hInput_HotKey)

	;-------------------------------------------check
	If $tmp_bBadSeparatorMode Then
		If $tmp_sBadSeparatorFirst == "" Or $tmp_sBadSeparatorSecond == "" Or $tmp_sBadSeparatorThird == "" Then
			Return 10
		EndIf
	EndIf
	;-----------------
	Select
		Case $bHotKeyMode And Not $tmp_bHotKeyMode            ;HotKeyMode diasable
			If $iHotKeyCode <> 0 Then
				HotKeySet($sHotKey)                ;deregistration old(!) HotKey
			EndIf
		Case Not $bHotKeyMode And $tmp_bHotKeyMode            ;HotKeyMode enable
			If $tmp_iHotKeyCode <> 0 Then
				$tmp_sHotKey = _GUICtrlHotkey_GetHotkey($hInput_HotKey)
				_FixAccelHotKeyLayout()
				$iErr = RegistrationHotkey($tmp_sHotKey)
				If $iErr <> 0 Then
					Return $iErr    ;occupied
				EndIf
			Else
				Return 13
			EndIf
		Case $bHotKeyMode And $tmp_bHotKeyMode                ;Change HotKey
			If $tmp_iHotKeyCode <> 0 Then
				If $tmp_iHotKeyCode <> $iHotKeyCode Then
					$tmp_sHotKey = _GUICtrlHotkey_GetHotkey($hInput_HotKey)
					_FixAccelHotKeyLayout()
					$iErr = RegistrationHotkey($tmp_sHotKey)
					If $iErr <> 0 Then
						Return $iErr    ;occupied
					EndIf
					If $iHotKeyCode <> 0 Then
						HotKeySet($sHotKey)                ;deregistration old(!) HotKey after successfull registration new HotKey
					EndIf
				EndIf
			Else
				Return 13
			EndIf

	EndSelect

	;-------------------------------------------write
	Switch $sArchitecture
		Case "X64"
			RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "FPSMode", "REG_DWORD", $tmp_nFPSMode)
			RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "TrainingMode", "REG_DWORD", $tmp_bTrainingMode)
			RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "DropSeparatorMode", "REG_DWORD", $tmp_nDropSeparatorMode)
			RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "BadSeparatorMode", "REG_DWORD", $tmp_bBadSeparatorMode)
			If $tmp_bBadSeparatorMode Then
				RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "BadSeparatorFirst", "REG_DWORD", Asc($tmp_sBadSeparatorFirst))
				RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "BadSeparatorSecond", "REG_DWORD", Asc($tmp_sBadSeparatorSecond))
				RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "BadSeparatorThird", "REG_DWORD", Asc($tmp_sBadSeparatorThird))
			EndIf
			RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "HotKeyMode", "REG_DWORD", $tmp_bHotKeyMode)
			If $tmp_bHotKeyMode Then
				RegWrite("HKCU64\Software\NyBumBum\tcCalculator", "HotKeyCode", "REG_DWORD", $tmp_iHotKeyCode)
			EndIf
		Case "X86"
			RegWrite("HKCU\Software\NyBumBum\tcCalculator", "FPSMode", "REG_DWORD", $tmp_nFPSMode)
			RegWrite("HKCU\Software\NyBumBum\tcCalculator", "TrainingMode", "REG_DWORD", $tmp_bTrainingMode)
			RegWrite("HKCU\Software\NyBumBum\tcCalculator", "DropSeparatorMode", "REG_DWORD", $tmp_nDropSeparatorMode)
			RegWrite("HKCU\Software\NyBumBum\tcCalculator", "BadSeparatorMode", "REG_DWORD", $tmp_bBadSeparatorMode)
			If $tmp_bBadSeparatorMode Then
				RegWrite("HKCU\Software\NyBumBum\tcCalculator", "BadSeparatorFirst", "REG_DWORD", Asc($tmp_sBadSeparatorFirst))
				RegWrite("HKCU\Software\NyBumBum\tcCalculator", "BadSeparatorSecond", "REG_DWORD", Asc($tmp_sBadSeparatorSecond))
				RegWrite("HKCU\Software\NyBumBum\tcCalculator", "BadSeparatorThird", "REG_DWORD", Asc($tmp_sBadSeparatorThird))
			EndIf
			RegWrite("HKCU\Software\NyBumBum\tcCalculator", "HotKeyMode", "REG_DWORD", $tmp_bHotKeyMode)
			If $tmp_bHotKeyMode Then
				RegWrite("HKCU\Software\NyBumBum\tcCalculator", "HotKeyCode", "REG_DWORD", $tmp_iHotKeyCode)
			EndIf
	EndSwitch
	;--------------------------------------approve changes
	$nFPSMode = $tmp_nFPSMode
	$bTrainingMode = $tmp_bTrainingMode
	$nDropSeparatorMode = $tmp_nDropSeparatorMode
	$bBadSeparatorMode = $tmp_bBadSeparatorMode
	If $tmp_bBadSeparatorMode Then
		$sBadSeparatorFirst = $tmp_sBadSeparatorFirst
		$sBadSeparatorSecond = $tmp_sBadSeparatorSecond
		$sBadSeparatorThird = $tmp_sBadSeparatorThird
	EndIf
	$bHotKeyMode = $tmp_bHotKeyMode
	If $tmp_bHotKeyMode Then
		$iHotKeyCode = $tmp_iHotKeyCode
		$sHotKey = $tmp_sHotKey
	EndIf

	Return 0
EndFunc   ;==>SetRegistry
#EndRegion;------------------------------------------------------------------------------------
#Region ;--------------------Get Registry------------------------------------------------------
Func GetRegistry()
	Local $nBS1, $nBS2, $nBS3
	If $sArchitecture = "X64" Then
		$nFPSMode = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "FPSMode")
		$bTrainingMode = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "TrainingMode")
		$nDropSeparatorMode = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "DropSeparatorMode")
		$bBadSeparatorMode = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "BadSeparatorMode")
		;--------------------------------------------------------------------------
		$nBS1 = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "BadSeparatorFirst")
		If $nBS1 = 33 Or $nBS1 = 35 Or $nBS1 = 36 Or $nBS1 = 37 Or $nBS1 = 38 Or $nBS1 = 42 Or $nBS1 = 44 Or $nBS1 = 45 Or $nBS1 = 46 Or $nBS1 = 58 Or $nBS1 = 59 Or $nBS1 = 63 Or $nBS1 = 64 Or $nBS1 = 96 Or $nBS1 = 124 Or $nBS1 = 126 Then
			$sBadSeparatorFirst = Chr($nBS1)
		Else
			$sBadSeparatorFirst = ""
		EndIf
		;-----------------------
		$nBS2 = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "BadSeparatorSecond")
		If $nBS2 = 33 Or $nBS2 = 35 Or $nBS2 = 36 Or $nBS2 = 37 Or $nBS2 = 38 Or $nBS2 = 42 Or $nBS2 = 44 Or $nBS2 = 45 Or $nBS2 = 46 Or $nBS2 = 58 Or $nBS2 = 59 Or $nBS2 = 63 Or $nBS2 = 64 Or $nBS2 = 96 Or $nBS2 = 124 Or $nBS2 = 126 Then
			$sBadSeparatorSecond = Chr($nBS2)
		Else
			$sBadSeparatorSecond = ""
		EndIf
		;-----------------------
		$nBS3 = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "BadSeparatorThird")
		If $nBS3 = 33 Or $nBS3 = 35 Or $nBS3 = 36 Or $nBS3 = 37 Or $nBS3 = 38 Or $nBS3 = 42 Or $nBS3 = 44 Or $nBS3 = 45 Or $nBS3 = 46 Or $nBS3 = 58 Or $nBS3 = 59 Or $nBS3 = 63 Or $nBS3 = 64 Or $nBS3 = 96 Or $nBS3 = 124 Or $nBS3 = 126 Then
			$sBadSeparatorThird = Chr($nBS3)
		Else
			$sBadSeparatorThird = ""
		EndIf
		;-------------------------------------------------------------------------
		$bHotKeyMode = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "HotKeyMode")
		$iHotKeyCode = RegRead("HKCU64\Software\NyBumBum\tcCalculator", "HotKeyCode")
	ElseIf $sArchitecture = "X86" Then
		$nFPSMode = RegRead("HKCU\Software\NyBumBum\tcCalculator", "FPSMode")
		$bTrainingMode = RegRead("HKCU\Software\NyBumBum\tcCalculator", "TrainingMode")
		$nDropSeparatorMode = RegRead("HKCU\Software\NyBumBum\tcCalculator", "DropSeparatorMode")
		$bBadSeparatorMode = RegRead("HKCU\Software\NyBumBum\tcCalculator", "BadSeparatorMode")
		;-------------------------------------------------------------------------
		$nBS1 = RegRead("HKCU\Software\NyBumBum\tcCalculator", "BadSeparatorFirst")
		If $nBS1 = 33 Or $nBS1 = 35 Or $nBS1 = 36 Or $nBS1 = 37 Or $nBS1 = 38 Or $nBS1 = 42 Or $nBS1 = 44 Or $nBS1 = 45 Or $nBS1 = 46 Or $nBS1 = 58 Or $nBS1 = 59 Or $nBS1 = 63 Or $nBS1 = 64 Or $nBS1 = 96 Or $nBS1 = 124 Or $nBS1 = 126 Then
			$sBadSeparatorFirst = Chr($nBS1)
		Else
			$sBadSeparatorFirst = ""
		EndIf
		;-----------------------
		$nBS2 = RegRead("HKCU\Software\NyBumBum\tcCalculator", "BadSeparatorSecond")
		If $nBS2 = 33 Or $nBS2 = 35 Or $nBS2 = 36 Or $nBS2 = 37 Or $nBS2 = 38 Or $nBS2 = 42 Or $nBS2 = 44 Or $nBS2 = 45 Or $nBS2 = 46 Or $nBS2 = 58 Or $nBS2 = 59 Or $nBS2 = 63 Or $nBS2 = 64 Or $nBS2 = 96 Or $nBS2 = 124 Or $nBS2 = 126 Then
			$sBadSeparatorSecond = Chr($nBS2)
		Else
			$sBadSeparatorSecond = ""
		EndIf
		;-----------------------
		$nBS3 = RegRead("HKCU\Software\NyBumBum\tcCalculator", "BadSeparatorThird")
		If $nBS3 = 33 Or $nBS3 = 35 Or $nBS3 = 36 Or $nBS3 = 37 Or $nBS3 = 38 Or $nBS3 = 42 Or $nBS3 = 44 Or $nBS3 = 45 Or $nBS3 = 46 Or $nBS3 = 58 Or $nBS3 = 59 Or $nBS3 = 63 Or $nBS3 = 64 Or $nBS3 = 96 Or $nBS3 = 124 Or $nBS3 = 126 Then
			$sBadSeparatorThird = Chr($nBS3)
		Else
			$sBadSeparatorThird = ""
		EndIf
		;-------------------------------------------------------------------------
		$bHotKeyMode = RegRead("HKCU\Software\NyBumBum\tcCalculator", "HotKeyMode")
		$iHotKeyCode = RegRead("HKCU\Software\NyBumBum\tcCalculator", "HotKeyCode")
	Else
		MsgBox($MB_ICONINFORMATION, "IA64", "Itanium is not supported")
		Exit
	EndIf
EndFunc   ;==>GetRegistry
#EndRegion ;--------------------Get Registry------------------------------------------------------

;---------------------------------------------------------------------------------------------(by musicstashall)
Func _NoContextMenuInput_Bad_1($h_Wnd, $i_Msg, $w_Param, $l_Param)
	Switch $i_Msg
		Case $WM_CONTEXTMENU
			Switch $h_Wnd
				Case $hInput_Bad_1
					Return 0
			EndSwitch
	EndSwitch
	Return _WinAPI_CallWindowProc($apPTR_Bad_1[0], $h_Wnd, $i_Msg, $w_Param, $l_Param)
EndFunc   ;==>_NoContextMenuInput_Bad_1

Func _NoContextMenuInput_Bad_2($h_Wnd, $i_Msg, $w_Param, $l_Param)
	Switch $i_Msg
		Case $WM_CONTEXTMENU
			Switch $h_Wnd
				Case $hInput_Bad_2
					Return 0
			EndSwitch
	EndSwitch
	Return _WinAPI_CallWindowProc($apPTR_Bad_2[0], $h_Wnd, $i_Msg, $w_Param, $l_Param)
EndFunc   ;==>_NoContextMenuInput_Bad_2

Func _NoContextMenuInput_Bad_3($h_Wnd, $i_Msg, $w_Param, $l_Param)
	Switch $i_Msg
		Case $WM_CONTEXTMENU
			Switch $h_Wnd
				Case $hInput_Bad_3
					Return 0
			EndSwitch
	EndSwitch
	Return _WinAPI_CallWindowProc($apPTR_Bad_3[0], $h_Wnd, $i_Msg, $w_Param, $l_Param)
EndFunc   ;==>_NoContextMenuInput_Bad_3

#Region;-------------------------------------------------------------------------------------------------------------- Format (method by...)
Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0xFFFF)
	Local $hCtrl = $lParam
	Switch $nID
		Case $idInput
			Switch $nNotifyCode
				Case $EN_UPDATE ;, $EN_CHANGE
					Switch $nInputMode
						Case 1    ;---------------------------------------------------------------------------------------- timecode
							$aSel = _GUICtrlEdit_GetSel($idInput)
							$sOld = GUICtrlRead($idInput)
							Local $tmp = $sOld
							Switch $iDiffBeforeSel
								Case 0    ;------------------------------------------------------------------------ 0
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 3, 4, 6, 7, 9, 10
												$aSel[0] += 1
												$aSel[1] += 1
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 2, 3, 5, 6, 8, 9, 10 ;normal
												$aSel[0] += 1
												$aSel[1] += 1
											Case 1, 4, 7      ;jump
												$aSel[0] += 2
												$aSel[1] += 2
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_0()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_0()
									EndIf
								Case 1    ;---------------------------------------------------------------------- 1
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 3, 4, 6, 7, 9, 10
												$aSel[0] += 1
												$aSel[1] += 1
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ;2,5,8
												$aSel[0] += 1
												$aSel[1] += 1
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_1()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_1()
										;---------------------------------------------------------
									Else
										Switch $aSel[0]
											Case 3, 6, 9
												$tmp = StringLeft($sOld, $aSel[0] - 1) & StringMid($sOld, $aSel[0] + 1)
										EndSwitch
									EndIf
								Case 2    ;----------------------------------------------------------------------- 2
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
												$aSel[0] += 2
												$aSel[1] += 2
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
												$aSel[0] += 2
												$aSel[1] += 2
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_2()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_2()
										;---------------------------------------------------------
									Else
										Switch $aBeforeSel[0]    ;It's not error
											Case 2, 5, 8
												$aSel[0] += 1
												$aSel[1] += 1
										EndSwitch
									EndIf
								Case 3 ;------------------------------------------------------------------------------------- 3
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6, 7, 8
												$aSel[0] += 3
												$aSel[1] += 3
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6, 7, 8
												$aSel[0] += 3
												$aSel[1] += 3
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_3()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_3()
										;----------------------------------------------------------
									Else    ;$aBeforeSel is not needed
										$aSel[0] += 1
										$aSel[1] += 1
									EndIf
								Case 4 ;-------------------------------------------------------------------------------------- 4
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6, 7
												$aSel[0] += 4
												$aSel[1] += 4
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6, 7
												$aSel[0] += 4
												$aSel[1] += 4
										EndSwitch
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_4()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_4()
									Else    ;$aBeforeSel is not needed
										$aSel[0] += 1
										$aSel[1] += 1
									EndIf
								Case 5 ;--------------------------------------------------------------------------------------- 5
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6
												$aSel[0] += 5
												$aSel[1] += 5
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5, 6
												$aSel[0] += 5
												$aSel[1] += 5
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_5()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_5()
										;---------------------------------------------------------
									Else
										Switch $aBeforeSel[0]
											;It's not a error!!!
											;Positioning by original selection to implement the golden rule.
											;Inserting a different number of digits creates collisions of identical final coordinates.
											Case 0, 3, 6
												$aSel[0] += 1
												$aSel[1] += 1
											Case 1, 2, 4, 5
												$aSel[0] += 2
												$aSel[1] += 2
										EndSwitch
									EndIf
								Case 6 ;---------------------------------------------------------------------------------------- 6
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5
												$aSel[0] += 6
												$aSel[1] += 6
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4, 5
												$aSel[0] += 6
												$aSel[1] += 6
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_6()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_6()
									Else
										$aSel[0] += 2
										$aSel[1] += 2
									EndIf
								Case 7 ;---------------------------------------------------------------------------------------- 7
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4
												$aSel[0] += 7
												$aSel[1] += 7
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2, 3, 4
												$aSel[0] += 7
												$aSel[1] += 7
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_7()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_7()
										;---------------------------------------------------------
									Else
										Switch $aBeforeSel[0]    ;It's not a error
											Case 0, 1, 3, 4
												$aSel[0] += 2
												$aSel[1] += 2
											Case 2
												$aSel[0] += 3
												$aSel[1] += 3
										EndSwitch
									EndIf
								Case 8 ;---------------------------------------------------------------------------------------- 8
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 2, 3
												$aSel[0] += 8
												$aSel[1] += 8
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2, 3
												$aSel[0] += 8
												$aSel[1] += 8
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_8()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_8()
										;---------------------------------------------------------
									Else
										Switch $aBeforeSel[0]    ;It's not a error
											Case 0, 3
												$aSel[0] += 2
												$aSel[1] += 2
											Case 1, 2
												$aSel[0] += 3
												$aSel[1] += 3
										EndSwitch
									EndIf
								Case 9 ;---------------------------------------------------------------------------------------- 9
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1, 2
												$aSel[0] += 9
												$aSel[1] += 9
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1, 2
												$aSel[0] += 9
												$aSel[1] += 9
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_9()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_9()
										;---------------------------------------------------------
									Else
										$aSel[0] += 3
										$aSel[1] += 3
									EndIf
								Case 10 ;---------------------------------------------------------------------------------------- 10
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0, 1
												$aSel[0] += 10
												$aSel[1] += 10
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0, 1
												$aSel[0] += 10
												$aSel[1] += 10
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_10()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_10()
										;---------------------------------------------------------
									Else
										$aSel[0] += 3
										$aSel[1] += 3
									EndIf
								Case 11 ;---------------------------------------------------------------------------------------- 11
									If _IsPressed("08", $hDLL) Then                        ;BACKSPACE
										Switch $aSel[0]
											Case 0
												$aSel[0] += 11
												$aSel[1] += 11
										EndSwitch
										;----------------------------------------------------------
									ElseIf _IsPressed("2E", $hDLL) Then                    ;DELETE
										Switch $aSel[0]
											Case 0
												$aSel[0] += 11
												$aSel[1] += 11
										EndSwitch
										;---------------------------------------------------------
									ElseIf _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(0)
									ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(1)
									ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(2)
									ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(3)
									ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(4)
									ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(5)
									ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(6)
									ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(7)
									ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(8)
									ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
										$tmp = FormatForNumber_Sel_11()
										ButtonBlinking(9)
									ElseIf $aMsg[0] = $idButton_0 Or $aMsg[0] = $idButton_1 Or $aMsg[0] = $idButton_2 Or $aMsg[0] = $idButton_3 Or $aMsg[0] = $idButton_4 Or $aMsg[0] = $idButton_5 Or $aMsg[0] = $idButton_6 Or $aMsg[0] = $idButton_7 Or $aMsg[0] = $idButton_8 Or $aMsg[0] = $idButton_9 Then
										$tmp = FormatForNumber_Sel_11()
										;---------------------------------------------------------
									Else
										$aSel[0] += 3
										$aSel[1] += 3
									EndIf
							EndSwitch
							$iDiffBeforeSel = 0

							Local $str = StringFormat("%08d", Number(StringRegExpReplace($tmp, "[^0-9]", "")))
							$iHours = StringMid($str, 1, 2)
							$iMinutes = StringMid($str, 3, 2)
							$iSeconds = StringMid($str, 5, 2)
							$iFrames = StringMid($str, 7, 2)
							GUICtrlSetData($idInput, StringFormat("%02d", $iHours) & $sSeparatorFirst & StringFormat("%02d", $iMinutes) & $sSeparatorSecond & StringFormat("%02d", $iSeconds) & $sSeparatorThird & StringFormat("%02d", $iFrames))

							_GUICtrlEdit_SetSel($idInput, $aSel[0], $aSel[1])

						Case 2 ;------------------------------------------------------------------------- frame
							$aSel = _GUICtrlEdit_GetSel($idInput)
							$sOld = GUICtrlRead($idInput)

							If _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
								ButtonBlinking(0)
							ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
								ButtonBlinking(1)
							ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
								ButtonBlinking(2)
							ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
								ButtonBlinking(3)
							ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
								ButtonBlinking(4)
							ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
								ButtonBlinking(5)
							ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
								ButtonBlinking(6)
							ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
								ButtonBlinking(7)
							ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
								ButtonBlinking(8)
							ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
								ButtonBlinking(9)
							EndIf

							Local $temp2 = Number(StringRegExpReplace($sOld, "[^0-9]", ""))
							GUICtrlSetData($idInput, $temp2)
							_GUICtrlEdit_SetSel($idInput, $aSel[0], $aSel[1])
						Case 3 ;-------------------------------------------------------------------------- integer
							$aSel = _GUICtrlEdit_GetSel($idInput)
							$sOld = GUICtrlRead($idInput)

							If _IsPressed("30", $hDLL) Or _IsPressed("60", $hDLL) Then
								ButtonBlinking(0)
							ElseIf _IsPressed("31", $hDLL) Or _IsPressed("61", $hDLL) Then
								ButtonBlinking(1)
							ElseIf _IsPressed("32", $hDLL) Or _IsPressed("62", $hDLL) Then
								ButtonBlinking(2)
							ElseIf _IsPressed("33", $hDLL) Or _IsPressed("63", $hDLL) Then
								ButtonBlinking(3)
							ElseIf _IsPressed("34", $hDLL) Or _IsPressed("64", $hDLL) Then
								ButtonBlinking(4)
							ElseIf _IsPressed("35", $hDLL) Or _IsPressed("65", $hDLL) Then
								ButtonBlinking(5)
							ElseIf _IsPressed("36", $hDLL) Or _IsPressed("66", $hDLL) Then
								ButtonBlinking(6)
							ElseIf _IsPressed("37", $hDLL) Or _IsPressed("67", $hDLL) Then
								ButtonBlinking(7)
							ElseIf _IsPressed("38", $hDLL) Or _IsPressed("68", $hDLL) Then
								ButtonBlinking(8)
							ElseIf _IsPressed("39", $hDLL) Or _IsPressed("69", $hDLL) Then
								ButtonBlinking(9)
							EndIf

							Local $temp3 = Number(StringRegExpReplace($sOld, "[^0-9]", ""))
							GUICtrlSetData($idInput, $temp3)
							_GUICtrlEdit_SetSel($idInput, $aSel[0], $aSel[1])
					EndSwitch
			EndSwitch
			;-------------------------------------------------------------------------------------------------
		Case $idInput_Bad_1
			Switch $nNotifyCode
				Case $EN_UPDATE
					Local $sBad_1 = StringRegExpReplace(GUICtrlRead($idInput_Bad_1), "[^!#$%&*,-.:;?@`|~]", "")
					GUICtrlSetData($idInput_Bad_1, $sBad_1)
			EndSwitch
			;-------------------------------------------------------------------------------------------------
		Case $idInput_Bad_2
			Switch $nNotifyCode
				Case $EN_UPDATE
					Local $sBad_2 = StringRegExpReplace(GUICtrlRead($idInput_Bad_2), "[^!#$%&*,-.:;?@`|~]", "")
					GUICtrlSetData($idInput_Bad_2, $sBad_2)
			EndSwitch
			;-------------------------------------------------------------------------------------------------
		Case $idInput_Bad_3
			Switch $nNotifyCode
				Case $EN_UPDATE
					Local $sBad_3 = StringRegExpReplace(GUICtrlRead($idInput_Bad_3), "[^!#$%&*,-.:;?@`|~]", "")
					GUICtrlSetData($idInput_Bad_3, $sBad_3)
			EndSwitch
			;-------------------------------------------------------------------------------------------------
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>_WM_COMMAND
;----------------------------------------------------------------------------------------- 0
Func FormatForNumber_Sel_0()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 0, 1, 4, 7, 10, 11 ;normal
			$tmp = StringLeft($sOld, $aSel[0]) & StringMid($sOld, $aSel[0] + 2)
		Case 2, 5, 8          ;jump
			$tmp = StringLeft($sOld, $aSel[0]) & StringMid($sOld, $aSel[0] + 2)
			$aSel[0] += 1
			$aSel[1] += 1
		Case 3, 6, 9          ;before separator
			$tmp = StringLeft($sOld, $aSel[0] - 1) & StringMid($sOld, $aSel[0] + 1) ;skip
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_0
;----------------------------------------------------------------------------------------- 1
Func FormatForNumber_Sel_1()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 3, 6, 9
			$tmp = StringLeft($sOld, $aSel[0] - 1) & StringMid($sOld, $aSel[0] + 1)
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_1
;----------------------------------------------------------------------------------------- 2
Func FormatForNumber_Sel_2()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1, 4, 7, 10
			$tmp = StringLeft($sOld, $aSel[0]) & 0 & StringMid($sOld, $aSel[0] + 2)
		Case 2, 3, 5, 6, 8, 9
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_2
;----------------------------------------------------------------------------------------- 3
Func FormatForNumber_Sel_3()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1, 4, 7
			$tmp = StringLeft($sOld, $aSel[0]) & 0 & StringMid($sOld, $aSel[0] + 1)
		Case 2, 3, 5, 6, 8, 9
			$tmp = StringLeft($sOld, $aSel[0]) & 0 & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_3
;----------------------------------------------------------------------------------------- 4
Func FormatForNumber_Sel_4()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1, 4, 7
			$tmp = StringLeft($sOld, $aSel[0]) & "00" & StringMid($sOld, $aSel[0] + 1)
		Case 2, 5, 8
			$tmp = StringLeft($sOld, $aSel[0]) & "00" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
		Case 3, 6
			$tmp = StringLeft($sOld, $aSel[0]) & "0" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_4
;----------------------------------------------------------------------------------------- 5
Func FormatForNumber_Sel_5()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1, 4, 7
			$tmp = StringLeft($sOld, $aSel[0]) & "000" & StringMid($sOld, $aSel[0] + 2)
		Case 2, 3, 5, 6
			$tmp = StringLeft($sOld, $aSel[0]) & "00" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_5
;----------------------------------------------------------------------------------------- 6
Func FormatForNumber_Sel_6()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1, 4
			$tmp = StringLeft($sOld, $aSel[0]) & "000" & StringMid($sOld, $aSel[0] + 1)
		Case 2, 3, 5, 6
			$tmp = StringLeft($sOld, $aSel[0]) & "000" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_6
;----------------------------------------------------------------------------------------- 7
Func FormatForNumber_Sel_7()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1, 4
			$tmp = StringLeft($sOld, $aSel[0]) & "0000" & StringMid($sOld, $aSel[0] + 1)
		Case 2, 5
			$tmp = StringLeft($sOld, $aSel[0]) & "0000" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
		Case 3
			$tmp = StringLeft($sOld, $aSel[0]) & "000" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_7
;----------------------------------------------------------------------------------------- 8
Func FormatForNumber_Sel_8()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1, 4
			$tmp = StringLeft($sOld, $aSel[0]) & "00000" & StringMid($sOld, $aSel[0] + 2)
		Case 2, 3
			$tmp = StringLeft($sOld, $aSel[0]) & "0000" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_8
;----------------------------------------------------------------------------------------- 9
Func FormatForNumber_Sel_9()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1
			$tmp = StringLeft($sOld, $aSel[0]) & "00000" & StringMid($sOld, $aSel[0] + 1)
		Case 2, 3
			$tmp = StringLeft($sOld, $aSel[0]) & "00000" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_9
;----------------------------------------------------------------------------------------- 10
Func FormatForNumber_Sel_10()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1
			$tmp = StringLeft($sOld, $aSel[0]) & "000000" & StringMid($sOld, $aSel[0] + 1)
		Case 2
			$tmp = StringLeft($sOld, $aSel[0]) & "000000" & StringMid($sOld, $aSel[0] + 1)
			$aSel[0] += 1
			$aSel[1] += 1
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_10
;----------------------------------------------------------------------------------------- 11
Func FormatForNumber_Sel_11()
	Local $tmp = $sOld
	Switch $aSel[0]
		Case 1
			$tmp = StringLeft($sOld, $aSel[0]) & "0000000"
	EndSwitch
	Return $tmp
EndFunc   ;==>FormatForNumber_Sel_11
#EndRegion;-----------------------------------------------------------------------------------------
Func ButtonBlinking($nBtn)
	Switch $nBtn
		Case 0
			_SendMessage($hButton_0, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_0, $BM_SETSTATE, False)
		Case 1
			_SendMessage($hButton_1, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_1, $BM_SETSTATE, False)
		Case 2
			_SendMessage($hButton_2, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_2, $BM_SETSTATE, False)
		Case 3
			_SendMessage($hButton_3, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_3, $BM_SETSTATE, False)
		Case 4
			_SendMessage($hButton_4, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_4, $BM_SETSTATE, False)
		Case 5
			_SendMessage($hButton_5, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_5, $BM_SETSTATE, False)
		Case 6
			_SendMessage($hButton_6, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_6, $BM_SETSTATE, False)
		Case 7
			_SendMessage($hButton_7, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_7, $BM_SETSTATE, False)
		Case 8
			_SendMessage($hButton_8, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_8, $BM_SETSTATE, False)
		Case 9
			_SendMessage($hButton_9, $BM_SETSTATE, True)
			Sleep(5)
			_SendMessage($hButton_9, $BM_SETSTATE, False)
	EndSwitch
EndFunc   ;==>ButtonBlinking
;----------------------------------------------------------------------------------Custom Input Menu (by rasim)
Func _WindowProc($hWnd, $Msg, $wParam, $lParam)
	Switch $hWnd
		Case GUICtrlGetHandle($idInput)
			Switch $Msg
				Case $WM_CONTEXTMENU
					_GUICtrlMenu_TrackPopupMenu($hContextMenu_Input, $wParam)
					Return 1
				Case $WM_COMMAND
					Switch $wParam
						Case $WM_CUT, $WM_COPY, $WM_PASTE, $WM_CLEAR
							_SendMessage($hWnd, $wParam)
						Case $idSelectAll
							_SendMessage($hWnd, $EM_SETSEL, 0, -1)
					EndSwitch
			EndSwitch
	EndSwitch

	Local $aRet = DllCall("user32.dll", "int", "CallWindowProc", "ptr", $wProcOld, _
			"hwnd", $hWnd, "uint", $Msg, "wparam", $wParam, "lparam", $lParam)
	Return $aRet[0]
EndFunc   ;==>_WindowProc
;---------------------------------------------------------------------------------------Button Skin
Func SkinForButtons()
	Local $hImageList = _GUIImageList_Create(64, 51)
	Local $hBitmap = _WinAPI_LoadBitmap($hInstance, $ansArrayBtnImg[$i][$ii])
	_GUIImageList_Add($hImageList, $hBitmap)
	_GUICtrlButton_SetImageList($ansArrayBtnImg[$i][0], $hImageList, 4)
	Local $hImageList = _GUIImageList_Create(64, 51)
EndFunc   ;==>SkinForButtons
;--------------------------------------------------------------------------------------Parsing Data
Func ParsingData($sTC)
	$iHours = StringMid($sTC, 1, 2)
	$iMinutes = StringMid($sTC, 4, 2)
	$iSeconds = StringMid($sTC, 7, 2)
	$iFrames = StringMid($sTC, 10, 2) ;------------------>>> if fps >= 100 then 10, 3
EndFunc   ;==>ParsingData
;--------------------------------------------------------------------------------------------Errors
Func PrintError($iErr)
	Local $sErrorText = GetStringFromResources($anArayStringsErrors[$eUnknownError])                 ;"Unknown error"
	Switch $iErr
		Case 1
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eTimecodeInvalid])            ;"Timecode is invalid"
		Case 2
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eTimecodeIncorrect])          ;"Timecode is incorrect"
		Case 3
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eFramesInvalid])              ;"Frames is invalid"
		Case 4
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eFramesOverMax])              ;"The number of frames is higher than the maximum possible (for 24 hours with the current FPS)."
		Case 5
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eDrop])                       ;"Drop Frame. Such a timecode does not exist, cannot exist."
		Case 6
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eIntegerOverMax])             ;"An integer greater than the maximum (99)."
		Case 7
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eResultOverMax])              ;"The result is greater than the maximum (24 hours)."
		Case 8
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eNegativeNumber])             ;"Subtracting more from less. Negative values are not supported."
		Case 9
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eDivideByZero])               ;"You can't divide by zero."
		Case 10
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eCastomSeparatorEmpty])       ;"Custom separators cannot be empty. Either disable custom separators or define your separators."
		Case 11
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eHotKeyRegistrationDenied])   ;"This set of Hotkeys could not be registered in Windows (they may be occupied by another program). Try using a different set of hotkeys."
		Case 12
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eSavedHotKeyDeniedOnStart])   ;"Previously saved hotkeys could not be registered in Windows (they may be occupied by another program). Hotkeys are currently disabled. Try using a different set of hotkeys."
		Case 13
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eHotKeyEmpty])                ;"Hotkeys cannot be empty. Either disable hotkeys for Smart Paste or define your hotkeys."
		Case 14
			$sErrorText = GetStringFromResources($anArayStringsErrors[$eAlreadyRunning])             ;"tcCalculator is already running"
			MsgBox(0, GetStringFromResources($anArayStringsErrors[$eErrorTitle]), $sErrorText)
			Return         ;w/o focus
	EndSwitch
	MsgBox(0, GetStringFromResources($anArayStringsErrors[$eErrorTitle]), $sErrorText)               ;"Error"
	ControlFocus($hFormMain, "", $idInput)

EndFunc   ;==>PrintError

#Region ; -------------------------------------------------------------------------------------------Checks
Func CheckTC()
	Local $sTC = GUICtrlRead($idInput)
	Local $iLengthTC = StringLen($sTC)
	If $iLengthTC <> 11 Then
		Return 1
	EndIf
	ParsingData($sTC)
	If $iHours >= 24 Or $iMinutes >= 60 Or $iSeconds >= 60 Or $iFrames >= $iFPS Then
		Return 2
	EndIf
	If $bDropFrameMode Then
		If Mod($iMinutes, 10) <> 0 And $iSeconds = 0 And $iFrames < $iDropPerMinute Then
			Return 5
		EndIf
	EndIf
	Return 0
EndFunc   ;==>CheckTC
;-------------------------------------------------
Func CheckFramesMax($iF)
	Local $iFramesMax = (24 * 60 * 60 * $iFPS) - (24 * 6 * 9 * $iDropPerMinute)
	If $iF >= $iFramesMax Then
		Return 7
	EndIf
	$iTotalNumberFrames = $iF
	Return 0
EndFunc   ;==>CheckFramesMax
;--------------------------------------------------
Func CheckFrames()
	Local $iF = GUICtrlRead($idInput)
	Local $bOnlyDigit = StringIsDigit($iF)
	If Not $bOnlyDigit Then
		Return 3
	EndIf
	Local $iFramesMax = (24 * 60 * 60 * $iFPS) - (24 * 6 * 9 * $iDropPerMinute)
	If $iF >= $iFramesMax Then
		Return 4
	EndIf
	$iTotalNumberFrames = $iF
	Return 0
EndFunc   ;==>CheckFrames
;--------------------------------------------------
Func CheckInteger()
	Local $iInt = GUICtrlRead($idInput)
	If $iInt >= 100 Then
		Return 6
	EndIf
	If $nArithmeticOperation = 1 And $iInt = 0 Then
		Return 9
	EndIf

	$iTotalNumberFrames = $iInt
	Return 0
EndFunc   ;==>CheckInteger
#EndRegion ; -------------------------------------------------------------------------------------------Checks

#Region ;--------------------------Menu----------------------------------------------------
Func WM_EXITMENULOOP()    ;Menu button: Open-close with one button
	$hTimer = TimerInit()
EndFunc   ;==>WM_EXITMENULOOP

;--------------------Show a menu in a given GUI window which belongs to a given GUI ctrl-------------------------------
Func ShowMenu($hWnd, $CtrlID, $nContextID)
	Local $arPos, $x, $y
	Local $hMenu = GUICtrlGetHandle($nContextID)

	$arPos = ControlGetPos($hWnd, "", $CtrlID)

	$x = $arPos[0]
	$y = $arPos[1] + $arPos[3]

	ClientToScreen($hWnd, $x, $y)
	TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc   ;==>ShowMenu

;--------------------------- Convert the client (GUI) coordinates to screen (desktop) coordinates----------------------------
Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")

	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))

	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local
	$stPoint = 0
EndFunc   ;==>ClientToScreen

;--------------------Show at the given coordinates (x, y) the popup menu (hMenu) which belongs to a given GUI window (hWnd)-------------------
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>TrackPopupMenu
#EndRegion ;--------------------------Menu----------------------------------------------------

Func _FixAccelHotKeyLayout() ; by Creator
	Static $iKbrdLayout, $aKbrdLayouts

	If Execute('@exitMethod') <> '' Then
		Local $iUnLoad = 1

		For $i = 1 To UBound($aKbrdLayouts) - 1
			If Hex($iKbrdLayout) = Hex('0x' & StringRight($aKbrdLayouts[$i], 4)) Then
				$iUnLoad = 0
				ExitLoop
			EndIf
		Next

		If $iUnLoad Then
			_WinAPI_UnloadKeyboardLayout($iKbrdLayout)
		EndIf

		Return
	EndIf

	$iKbrdLayout = 0x0409
	$aKbrdLayouts = _WinAPI_GetKeyboardLayoutList()
	_WinAPI_LoadKeyboardLayout($iKbrdLayout, $KLF_ACTIVATE)

	OnAutoItExitRegister('_FixAccelHotKeyLayout')
EndFunc   ;==>_FixAccelHotKeyLayout

#Region ;--------------------------Conversion------algorithm by David Heidelberger------------------------------------------
Func ConversionTimeCodeToFrames()
	Local $iTotalNumberFramesNDF = (((($iHours * 60) + $iMinutes) * 60) + $iSeconds) * $iFPS + $iFrames    ; Sometimes magic numbers are better for understanding...
	Local $iTotalNumberDropFrames = 0
	If $bDropFrameMode Then
		Local $iTotalMinutes = (60 * $iHours) + $iMinutes
		$iTotalNumberDropFrames = ($iTotalMinutes - Int($iTotalMinutes / 10)) * $iDropPerMinute
	EndIf
	$iTotalNumberFrames = $iTotalNumberFramesNDF - $iTotalNumberDropFrames

EndFunc   ;==>ConversionTimeCodeToFrames
;--------------------------------------------------------------------------
Func ConversionFramesToTimeCode()
	If $bDropFrameMode Then
		Local $iFramePerMinute = (60 * $iFPS) - $iDropPerMinute              ; 1798
		Local $iFramePer10Minutes = 10 * 60 * $iFPS - 9 * $iDropPerMinute

		Local $iNumber10Minutes = Int($iTotalNumberFrames / $iFramePer10Minutes)
		Local $iModulo = Mod($iTotalNumberFrames, $iFramePer10Minutes)

		If $iModulo > $iDropPerMinute Then
			$iTotalNumberFrames += ($iDropPerMinute * 9 * $iNumber10Minutes) + Int($iDropPerMinute * Int(($iModulo - $iDropPerMinute) / $iFramePerMinute))
		Else
			$iTotalNumberFrames += $iDropPerMinute * 9 * $iNumber10Minutes
		EndIf
	EndIf

	$iFrames = Mod($iTotalNumberFrames, $iFPS)
	$iSeconds = Mod(Int($iTotalNumberFrames / $iFPS), 60)
	$iMinutes = Mod(Int(Int($iTotalNumberFrames / $iFPS) / 60), 60)
	$iHours = Int(Int(Int($iTotalNumberFrames / $iFPS) / 60) / 60)
EndFunc   ;==>ConversionFramesToTimeCode
#EndRegion ;--------------------------Conversion------algorithm by David Heidelberger------------------------------------------

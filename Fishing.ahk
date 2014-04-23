;-----------------------------------
;---- Defs -------------------------
;-----------------------------------

#SingleInstance force

global GUIscale := 2

;	large	3
;	normal	2
;	small	1
;	auto	0

global CloseAfterFinish := 0
global TotalRods := 1
global Repeat := 0
global Rods := Array()
global BotActive := 0

global GuiActive := 0
global IsFloatLocated := 0
global IsRodPixelAutodetected := 0

global WindowX := 0
global WindowY := 0
global WindowWidth := 600
global WindowHeight := 400

global OffsetX := 100
global OffsetY := 100
global RodSlotX := 279
global RodSlotY := 521

global RodPixelVerticalOffset := 25 ; 25 for normal GUI
global RodPixelHorizontalOffset := 3 ; 3 for normal GUI
global PanelSlotSize := 40 ; 40 for normal GUI, 60 for large GUI

;-----------------------------------

TrayTip, Remote Fisher, % "Open Minecraft, leave menu and inventories and then press K to start.", 20

;-----------------------------------
;---- Hotkeys ----------------------
;-----------------------------------

~*k::
{
	global BotActive

	If BotActive ; Not initial run
	{
		Send {PgUp}

		MsgBox, 4, Remote Fisher, Do you wish to stop the bot?

		IfMsgBox Yes
			ExitApp
		else
			Send {PgDn}
	}
	Else ; Initial run
	{
		WinGet, active_id, ID, A
		GroupAdd, Minecraft, ahk_id %active_id%
		WinGetPos, WindowX, WindowY, WindowWidth, WindowHeight, ahk_id %active_id%

		ActiveAreaCalc()
		FindRodPixel()
		FindAllRods()

		BotActive := 1

		Goto, GUI
	}
}
Return

#IfWinActive, Minecraft 1.7.2
~*PgDn::
{
	Repeat := 1

	Send {LControl Down}
	RodN := Rods[1]

	Loop
	{
		If Repeat = 0
		{
			Break
		}

		If LocateFloat() = 0
		{
			If IsRodCritical(RodN)
			{
				If RodN = %TotalRods% ; Последняя удочка
				{
					EndJob()
					Break
				}

				RodN := Rods[RodN+1]
			}

			Send %RodN%{RButton}
			Sleep 1400
		}
		Sleep 100
	}
}
Return

#IfWinActive, Minecraft 1.7.2
#If BotActive = 1
~*PgUp::
{
	Repeat := 0
	Send {LControl Up}
}
Return

;-----------------------------------
;---- Functions --------------------
;-----------------------------------

ActiveAreaCalc()
{
	global
	ActiveAreaX := OffsetX
	ActiveAreaY := OffsetY
	ActiveAreaWidth := WindowWidth - 2 * OffsetX
	ActiveAreaHeight := WindowHeight - 2 * OffsetY
	ActiveAreaXlow := WindowWidth - OffsetX
	ActiveAreaYlow := WindowHeight - OffsetY
	Return 0
}

FindRod(ByRef OutputVarX, ByRef OutputVarY, X1, Y1, X2, Y2)
{
	ImageSearch, OutputVarX, OutputVarY, X1, Y1, X2, Y2, *TransBlack *20 %A_ScriptDir%\rod_sample.png
	If ErrorLevel = 0
		Return 1 ; Found

	Return 0 ; Not found
}

FindCleanItem(ByRef OutputVarX, ByRef OutputVarY, X1, Y1, X2, Y2)
{
	ImageSearch, OutputVarX, OutputVarY, X1, Y1, X2, Y2, *TransBlack *20 %A_ScriptDir%\clean_sample.png
	If ErrorLevel = 0
		Return 1 ; Found

	Return 0 ; Not found
}

FindRodPixel()
{
	global RodSlotX
	global RodSlotY
	global IsRoadPixelAutodetected

	If FindRod(X, Y, 0, 0, 1920, 1080)
	{
		RodSlotX := X + RodPixelHorizontalOffset
		RodSlotY := Y + RodPixelVerticalOffset
		IsRoadPixelAutodetected := 1
		Return 1
	}
	
	Return 0
}

FindAllRods()
{
	i := 1
	global Rods := Array()
	global TotalRods := 0

	if FindRod(X0, Y0, 0, 0, 1920, 1080) = 0
		Return 0
	if FindCleanItem(X, Y, X0, Y0, X0 + PanelSlotSize, Y0 + PanelSlotSize) = 0
	{
		Rods[1] := 1
		TotalRods++
		i++
	}

	Loop 9
	{
		If (FindRod(X, Y, X0 + (i-1)*PanelSlotSize, Y0, X0 + i*PanelSlotSize, Y0+PanelSlotSize) = 1 and FindCleanItem(X, Y, X0 + (i-1)*PanelSlotSize, Y0, X0 + i*PanelSlotSize, Y0+PanelSlotSize) = 0)
		{
			Rods[i] := i
			TotalRods := i
		}

		i++
	}

	Return TotalRods
}

IsRodCritical(RodSlot)
{
	global RodSlotX
	global RodSlotY
	PixelGetColor, Pcolor, RodSlotX + 40 * (RodSlot - 1), RodSlotY, Alt
	If Pcolor = 0x003F3D
		Return 1
	Else
		Return 0
}

LocateFloat()
{
	global ActiveAreaX
	global ActiveAreaY
	global ActiveAreaWidth
	global ActiveAreaHeight

	; Day
	PixelSearch, FloatX, FloatY, %OffsetX%, %OffsetY%, %ActiveAreaWidth%, %ActiveAreaHeight%, 0x231E99, 39, Fast
	If ErrorLevel = 0
	{
		IsFloatLocated := 1
		Return 1
	}

	; Night
	PixelSearch, FloatX, FloatY, %OffsetX%, %OffsetY%, %ActiveAreaWidth%, %ActiveAreaHeight%, 0x1D1362, 10, Fast
	If ErrorLevel = 0
	{
		IsFloatLocated := 1
		Return 1
	}

	IsFloatLocated := 0
	Return 0
}

EndJob()
{
	Send {LControl Up}
	Repeat := 0
	If CloseAfterFinish
	{
		WinClose, Minecraft 1.7.2
	}
	MsgBox, 0, Remote Fisher, No more fishing rods. Stopped.,60
	ExitApp
	Return 0
}

MsgBox, Error out of code field range!
Pause, On


;-----------------------------------
;---- GUI --------------------------
;-----------------------------------


GUI:
	global IsRodPixelAutodetected
	global GuiActive := 1

	Gui, +AlwaysOnTop
	Gui, Font, s10

	If IsRodPixelAutodetected
	{
		Gui, Add, Text, section, Rod Pixel: autodetected!
	}
	Else
	{
		Gui, Add, Text, section, Rod Pixel: default...
	}
	Gui, Add, Button, ys gButtonDetect, Try detect

	Gui, Add, Text, section, Offset (h):
	Gui, Add, Text,, Offset (v):
	Gui, Add, Edit, ys Number vOffsetX, 100
	Gui, Add, Edit, Number vOffsetY, 100

	Gui, Add, Text, xm section, Rod pixel (h):
	Gui, Add, Text,, Rod pixel (v):
	If IsRodPixelAutodetected
	{
		Gui, Add, Edit, ys Number vRodSlotX, %RodSlotX%
		Gui, Add, Edit, Number vRodSlotY, %RodSlotY%
	}
	Else
	{
		Gui, Add, Edit, ys Number vRodSlotX, 279
		Gui, Add, Edit, Number vRodSlotY, 521
	}

	;Gui, Add, Text, xm section, Rods:			; Obsolete
	;Gui, Add, Edit, ys Number vTotalRods, 1
	Gui, Add, Button, ys gButtonPixel, Try pixel

	Gui, Add, Checkbox, xm section vCloseAfterFinish, Close after finish?

	Gui, Add, Button, xm section gButtonOK default, Submit

	Gui, Show, AutoSize, Remote Fisher
	WinWaitClose, ahk_id %GuiHWND%
Return

GuiClose:
ButtonOK:
Gui, Submit
Gui, Destroy
GuiActive := 0
Return

ButtonPixel:
Gui, Submit, NoHide
WinActivate, Minecraft 1.7.2
MouseMove, RodSlotX, RodSlotY
Return

ButtonDetect:
Gui, Submit, NoHide
WinActivate, Minecraft 1.7.2
Send {Esc}
FindRodPixel()
Return

; Nothing = 1 	;	Nothing - for fake commits; this means completely nothing, disregard this line.
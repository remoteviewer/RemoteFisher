/*	Рыболовный бот для Minecraft 1.7.2, версия 1.0

Запускать в AutoHotKey: http://www.autohotkey.com/

Используемые клавиши:
	'k' - в первый раз вызывает окно настроек. В остальных случаях выключает скрипт.
	'PageDown' - запускает рыбалку.
	'PageUp' - приостанавливает рыбалку.

Инструкция:

	0. Выставьте в майнкрафте настройки: яркость "100%", размер интерфейса "Large". Разверните окно на весь экран. Положите все удочки в их слоты в нижней панели (или хотя бы одну удочку в самый левый из тех слотов, что будут использованы для удочек). Освоо

	1. Поставьте текстурпак с непрозраной нижней панелью.
	1а.	Если нужно, замените изображения слота с удочкой и пустого слота, чтобы они подходили к текстурпаку.

	2. Запустите скрипт, должно появиться сообщение в трее.
		Оно гласит: "Откройте окно майнкрафта, выйдите из всех меню и инвентарей и нажмите K на клавиатуре."

	3. Нажмите клавишу 'k'. Появится окно настроек скрипта. В нем можно отредактировать числовые параметры.

	4. Нажмите кнопку "Try detect", откроется окно майнкрафта и найдется самая левая удочка.
		Перейдите снова в окно настроек, и нажмите "Try pixel", убрав руку с мышки. Курсор переместится. Если он окажется наведен на крайний левый пиксель полоски состояния удочки, то все в порядке. Если он промажет, подкорректируйте координаты в полях "Rod pixel" вручную, и снова нажмите "Try pixel". Вам нужно добиться точного попадания в область 3х3 пикселя. После этого переходите к следующему пункту.

	5. Если вы хотите выйти из майнкрафта после окончания рыбалки, отметьте галочку "Close after finish", после чего, наконец, закончите настройку нажатием "Submit".
		
	6. Нажмите клавишу 'PageDown' и откиньтесь в кресле. Свернуть окно, к сожалению, нельзя.

	7. Если хотите приостановить работу скрипта, нажмите 'PageUp', продолжить можно клавишей 'PageDown'.
		Выключить скрипт можно клавишей 'k', при этом выскочит подтверждающее окно.



Подробно об окне настроек скрипта:

	- Кнопка "Try detect" пытается обнаружить пиксель критического состояния удочки. Перед нажатием нужно положить все имеющиеся удочки в их слоты (или хотя бы одну удочку в самый левый из тех слотов, что будут использованы для удочек).
	Эта кнопка переходит в окно майнкрафта, нажимает Esc (чтобы выйти из меню игры) и ищет картинку удочки. К полученным координатам она применяет смещение и записывает полученные координаты в память.
	Этот процесс может сработать неверно. Результаты можно проверить и откорректировать вручную, об этом позднее.

	- Поля "Offset (h)" и ".. (v)" задают размеры поля, где будет искаться поплавок, а именно отступы от краев окна по горизонтали и по вертикали соответственно. Не рекомендуется менять. Это нужно, если окно майнкрафта маленькое.

	- Поля "Rod pixel (h)" и  ".. (v)" задают координаты пикселя критического состояния. Это самый левый пиксель в полоске состония предмета. Например, когда удочка близка к поломке, он становится красным, а когда удочка почти сломана, он становится черным. На самом деле эта область имеет размер примерно 3х3 пикселя, и нам подходит любой из них.
	В этих полях можно вручную подредактировать координаты этой точки, если другие способы не помогли.

	- Кнопка "Try pixel" наводит мышку туда, где по мнению бота, находится пиксель критического состояния. Она нужна, когда вы хотите проверить, правильно ли бот нашел этот пиксель. Нажав ее, проверьте, куда попала мышка. Если она навелась в левый конец полоски состояния - значит, все в порядке. Если промазала - подредактируйте поля "Rod pixel" самостоятельно. Это важно, потому что иначе бот будет работать неправильно.

	- Галочка "Close after finish" задает поведение бота при окончании рыбалки. Если галочка выставлена, то в конце рыбалки он грубо закроет окно игры.

	- Кнопка "Submit" записывает в память значения полей и закрывает окно настроек. Закрытие окна крестиком приведет к тому же. После этого бот готов к работе.

Используемые внешние файлы: 
	- rod_sample.png - вид удочки в нижней панели с отсечкой на уровне полоски состояния. Черные пиксели прозрачны для алгоритмов скрипта. Черными пикселями закрыт силуэт самой удочки, чтобы не влияла анимация энчанта.
	- clean_sample.png - вид пустого слота в нижней панели.


(c) Remote (aka Efrim), /mc/, April 2014

*/


;-----------------------------------
;---- Defs -------------------------
;-----------------------------------

#SingleInstance force

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
global WindowWidth := 1000
global WindowHeight := 800

global OffsetX := 300
global OffsetY := 200
global RodSlotX := 712
global RodSlotY := 1033

;-----------------------------------

TrayTip, Fisher, % "Open Minecraft, leave menu and inventories and then press K to start.", 20

;-----------------------------------
;---- Hotkeys ----------------------
;-----------------------------------

~*k::
{
	global BotActive

	If BotActive ; Not initial run
	{
		Send {PgUp}

		MsgBox, 4, Fisher, Stop bot?

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
		RodSlotX := X + 5
		RodSlotY := Y + 37
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
	if FindCleanItem(X, Y, X0, Y0, X0 + 60, Y0 + 60) = 0
	{
		Rods[1] := 1
		TotalRods++
		i++
	}

	Loop 9
	{
		If (FindRod(X, Y, X0 + (i-1)*60, Y0, X0 + i*60, Y0+60) = 1 and FindCleanItem(X, Y, X0 + (i-1)*60, Y0, X0 + i*60, Y0+60) = 0)
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
	PixelGetColor, Pcolor, RodSlotX + 60 * (RodSlot - 1), RodSlotY, Alt
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
	MsgBox, 0, Autofisher, No more fishing rods. Stopped.,60
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
	Gui, Add, Edit, ys Number vOffsetX, 300
	Gui, Add, Edit, Number vOffsetY, 200

	Gui, Add, Text, xm section, Rod pixel (h):
	Gui, Add, Text,, Rod pixel (v):
	If IsRodPixelAutodetected
	{
		Gui, Add, Edit, ys Number vRodSlotX, %RodSlotX%
		Gui, Add, Edit, Number vRodSlotY, %RodSlotY%
	}
	Else
	{
		Gui, Add, Edit, ys Number vRodSlotX, 712
		Gui, Add, Edit, Number vRodSlotY, 1033
	}

	;Gui, Add, Text, xm section, Rods:			; Obsolete
	;Gui, Add, Edit, ys Number vTotalRods, 1
	Gui, Add, Button, ys gButtonPixel, Try pixel

	Gui, Add, Checkbox, xm section vCloseAfterFinish, Close after finish?

	Gui, Add, Button, xm section gButtonOK default, Submit

	Gui, Show, AutoSize, Minecraft fishing bot
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
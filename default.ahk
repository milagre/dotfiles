;F1::
;WinGet, id, List,,, Program Manager
;Loop, %id%
;{
;    this_id := id%A_Index%
;    WinActivate, ahk_id %this_id%
;    WinGetClass, this_class, ahk_id %this_id%
;    WinGetTitle, this_title, ahk_id %this_id%
;    MsgBox, 4, , Visiting All Windows`n%A_Index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
;    IfMsgBox, NO, break
;}
;return

^!m::
active_window := WinExist("A")
SetTitleMatchMode, 1
GroupAdd, Zoom, Zoom
GroupAdd, Zoom, Meeting
WinActivate, ahk_group Zoom
Send, !a
WinActivate, ahk_id %active_window%

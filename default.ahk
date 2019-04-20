F1::
active_window := WinExist("A")
WinActivate, ahk_class Chrome_WidgetWin_1
Send, {Esc}
Sleep, 100
Send, T
Sleep, 100
Send, phishtracks.com
Sleep, 100
Send, {Enter}
Sleep, 100
Send, f
Sleep, 100
Send, m
Sleep, 100
Send, {^}
WinActivate, ahk_id %active_window%
return

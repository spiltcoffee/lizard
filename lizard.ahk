#Requires AutoHotkey v2.0
#SingleInstance Force

TraySetIcon("lizard.ico")
#NoTrayIcon

#Include xinput.ahk
XInput_Init()

SetTimer CloseTimer, 5 * 60 * 1000
Thread "Interrupt", 0

G := Gui(, "lizard")
G.AddPicture(, "lizard.png")
G.OnEvent("Close", CloseWindow)
G.Show()

~LButton:: Lizard
~RButton:: Lizard
~MButton:: Lizard
~WheelUp:: Lizard
~WheelDown:: Lizard
~WheelLeft:: Lizard
~WheelRight:: Lizard

SetTimer WaitAnyKey, 100
loop 4 {
  try {
    if State := XInput_GetState(A_Index - 1) {
      ControllerNumber := A_Index - 1
      PreviousState := State.wButtons
      SetTimer WaitAnyController, 100
      break
    }
  }
}

WaitAnyKey() {
  ih := InputHook("VL1",
    "{LButton}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}"
  )
  ih.Start()
  ih.Wait()
  Lizard()
}

WaitAnyController() {
  global ControllerNumber, PreviousState
  if State := XInput_GetState(ControllerNumber) {
    NewState := State.wButtons + State.bLeftTrigger + State.bRightTrigger
    if NewState != 0 AND NewState != PreviousState {
      Lizard()
    }
    PreviousState := NewState
  }
}

Lizard() {
  SoundPlay("lizard.mp3", 0)
}

CloseTimer() {
  ExitApp 0
}
CloseWindow(GuiObj) {
  ExitApp 0
}

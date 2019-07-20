; C:\Yosi\AHK\PublicProjects.git\Working_Hours\Work_Hours_script.ahk
; This script automatically save the aggregate working hours according to user activity on his PC
; 

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent
SetTitleMatchMode, 2
SoundBeep 500,60
MsgBox ,,, Work_Hours_script Wass reloaded ... Time: %A_Hour%:%A_Min%:%A_Sec%.,1

;
; Set variable initial velues
full_screen := 0
was_active := 0
aggregate_active_min := 0
aggregate_active_hour := 0
Delta := 0


;SetTimer, was_active_Timer, 5000
; 60000 (= 1 minute) ;   60000*5 = 300000 (5 minutes)  ; 50000 ( 10min <==> 1hour) 
; SetTimer, was_active_Timer, 50000  ;;; this line for debug and development of this script
SetTimer, was_active_Timer, 300000   ;;; this line for REAL MEASURMENT !!!
SetTimer, Mouse_Movement_Timer_Func, 100

; automatically create a C:\AHK folder
; is folder exist?
DirectoryCheckVar = C:\AHK
IfNotExist, %DirectoryCheckVar%
{
    FileCreateDir, C:\AHK
    if ErrorLevel   ; i.e. it's not blank or zero.
      MsgBox, Could not create "C:\AHK\"   folder,`n Please create it manualy :)
    else
      MsgBox,,, "C:\AHK\" folder was created `n Please dont delete it,5
}
else
{
    MsgBox,,, "C:\AHK\" Folder Exist,2
    ; read values from last script execution
    IfExist, C:\AHK\work_hour_params.txt
    {
      IniRead, a_last_YDay, C:\AHK\work_hour_params.txt, SISSION_DAY, a_last_YDay
      ; is the same day? A_YDay 
      if (a_last_YDay = A_YDay)
      {
        IniRead, aggregate_active_min, C:\AHK\work_hour_params.txt, AGGREGATE_MIN, aggregate_active_min
        IniRead, aggregate_active_hour, C:\AHK\work_hour_params.txt, AGGREGATE_HOUR, aggregate_active_hour
        ; todo: can lose up to five minutes of work due to 5 min quantization. (when reloading script)
        Progress, B cwWhite w800 c00 zh0 fs36, Aggregated time %aggregate_active_hour%:%aggregate_active_min%
        MsgBox, PAUSE
        Progress, Off
        MsgBox,,, Loaded params: `n hours: %aggregate_active_hour%`n minutes: %aggregate_active_min% ,3
      }
    }
}

; load variables from previous session


;---------------------------------------------------------------------------------------------------
;MButton - active indication
;~Tab::
;~Tab::
~Space::
~Tab::
~Enter::
~Escape::
~Backspace::
~Right::
~Left::
~Down::
~Up::
~PgDn::
~PgUp::
~End::
~Home::
~LButton::
~RButton::
~MButton::
~WheelDown::
~WheelUp::
was_active++
Progress,1: OFF  ; remove resting message 
return

Mouse_Movement_Timer_Func:
{
MouseGetPos, Start_PosX2, Start_PosY2
  if( (Start_PosX2 != Start_PosX1) && (Start_PosY2 != Start_PosY1))
  {
    Delta += Sqrt( (Start_PosX2-Start_PosX1)**2 + (Start_PosY2-Start_PosY1)**2 )
  }
  Start_PosX1 := Start_PosX2 
  Start_PosY1 := Start_PosY2 
  ;Sleep, 3000
  if(Delta > 400 )
  {
    Delta := 0
    was_active++
    Progress,1: OFF  ; remove resting message 
    ;ToolTip, Mouse_Movement_Delta%Delta%, 1000, 5
    SetTimer, tooltip_on_Timer, 3000
  }
return
}



;---------------------------------------------------------------------------------------------------
; (ctrl+win+R) : for reloading the macro
^#r::
Reload   ; yg20100211 - a shortkey for reload
SoundBeep,600, 10
Return

;; (alt+win+Enter) macro for testting diferent behaviors while developing
!#Enter::   ; dev testting
  if( not_work_flag ){
    Progress, Off
    sleep, 200
    Progress, B cwAqua w750 c00 zh0 fs36, in PLAYING session!!! %aggregate_active_min% minutes
    ;WinSet, TransColor, cwAqua 50, Work_Hours_script.ahk
  }else{
    Progress, B cwSilver w740 c00 zh0 fs36, in WORKING session!!! %aggregate_active_min% minutes
    ;WinSet, TransColor, cwSilver 75, Work_Hours_script.ahk
    ;WinSet, transparent, 100, Work_Hours_script.ahk
  }
  ;MsgBox, % Mod(aggregate_active_min, 60)
  x:="7"
  ;ComObjCreate("SAPI.SpVoice").Speak("aggregate active time" "minutes"%aggregate_active_min% )
  ;ComObjCreate("SAPI.SpVoice").Speak("aggregate active time" "minutes"%x% )
  ;string1 = "aggregate active time" %aggregate_active_min% "minutes" 
  string1 = "time" %aggregate_active_min% "minutes" 
  ComObjCreate("SAPI.SpVoice").Speak(string1)
  Progress, Off
return

; what is the default combination of ^+w in notepad++? (ctrl+shift+w) = (close all)
; so I can add (ctrl+shift+win+W) for WORKING context...
^+#w::
  SoundBeep,600, 10
  SoundBeep,600, 10
  not_work_flag := 0
  Progress, B cwSilver w450 c00 zh0 fs36, Get back to work
  sleep, 2500
  Progress, Off
return

; (ctrl+shift+win+P) for "PLAYING" context...
^+#p::   ; not work session, 
  SoundBeep,600, 10
  SoundBeep,600, 10
  not_work_flag := 1
  Progress, B cwAqua w750 c00 zh0 fs36, You ars in NOT WORK session!!!
  sleep, 2500
  Progress, Off
return

; so I can add (ctrl+shift+win+W) for WORKING context...
^+#v::
  Progress, B cwWhite w800 c00 zh0 fs36, Aggregated time %aggregate_active_hour%:%aggregate_active_min%
  MsgBox, PAUSE
  Progress, Off
return

;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;Gosub, SaveIarBreakPoint

; main timer: for aggragation of activity time.
was_active_Timer:
{
  ; is a new day?
  if !(a_last_YDay = A_YDay)
  {
      aggregate_active_min := 0
      aggregate_active_hour := 0 ;;??
  
  }
  
  if was_active > 0
  {
    ToolTip, was_active=%was_active%, 1150, 5
    was_active := 0
    if( not_work_flag = 0 )
    {
      aggregate_active_min += 5  ;in increments of 5 minutes
        string2 = "aggregate active time" %aggregate_active_min% "minutes" 
        ;ComObjCreate("SAPI.SpVoice").Speak(string2)
      
      ; send current time to "aggregate" file
      FormatTime, DateString, YYYYMMDDHH24MISS, yyyy_MM_dd__HH:mm
      FileAppend, %DateString%, C:\AHK\Aggregate_working_Hours.txt
      FileAppend, " agg min: ", C:\AHK\Aggregate_working_Hours.txt
      FileAppend, %aggregate_active_min%, C:\AHK\Aggregate_working_Hours.txt
      ; change persistant file
      IniWrite, %aggregate_active_min%, C:\AHK\work_hour_params.txt, AGGREGATE_MIN, aggregate_active_min
      
      ; Karōshi protection mechanism ("overwork death" in Japanese) 
      ; limit working hours to 8.5 hours a day!
      if( aggregate_active_min = 510 ){
        Progress, B cwGreen w850 c00 zh0 fs36, You worked today 8.5 hours!!! `n STOP WORKING
        ComObjCreate("SAPI.SpVoice").Speak("beware of overwork death")
        MsgBox, PAUSE
        Progress, Off
      }
      
      if( Mod(aggregate_active_min, 60) = 0 ){
        aggregate_active_hour++ ;
        string3 = "aggregate active time" %aggregate_active_hour% "Hours" 
        ComObjCreate("SAPI.SpVoice").Speak(string3)
        FileAppend, " Aggregate Hours: ", C:\AHK\Aggregate_working_Hours.txt
        FileAppend, %aggregate_active_hour%, C:\AHK\Aggregate_working_Hours.txt
        IniWrite, %aggregate_active_hour%, C:\AHK\work_hour_params.txt, AGGREGATE_HOUR, aggregate_active_hour
        ;MsgBox ,,, %aggregate_active_hour% Hours of work aggragated at ... Time: %A_Hour%:%A_Min%:%A_Sec%.,1
      }
      FileAppend, `n, C:\AHK\Aggregate_working_Hours.txt
    }else{
      Progress, B cwTeal w850 c00 zh0 fs36, You ars still in NOT WORK session!!!
      sleep, 1500
      Progress, Off
    }
  }
  else{
    ; give resting indication...
    aggregate_resting_min += 5
    if( Mod(aggregate_resting_min, 60) = 0 ){
      aggregate_resting_hour++
      aggregate_resting_min = 0
    }
    Progress,1: B cwWhite y10 w800 c00 zh0 fs36, Resting time: %aggregate_resting_hour%:%aggregate_resting_min%
  }
  SetTimer, tooltip_on_Timer, 3000
  a_last_YDay := A_YDay
  ; save the day
  IniWrite, %a_last_YDay%, C:\AHK\work_hour_params.txt, SISSION_DAY, a_last_YDay

  
}
return

tooltip_on_Timer:
{
  ToolTip
  SetTimer, tooltip_on_Timer, Off
}
return

DetectMouseMovement:
{
	MouseGetPos, g_xpos1, g_ypos1
	x_delta := g_xpos1 - g_xpos
	y_delta := g_ypos1 - g_ypos
	if( (g_xpos1 - g_xpos) != 0 ){
		SoundBeep,1700, 70
		ToolTip, Xx%x_delta%, 100, 100
	}
	if( (g_ypos1 - g_ypos) != 0 ){
		SoundBeep,1900, 70
		ToolTip, Yy%y_delta%, 100, 100
	}
	g_ypos := g_ypos1
	g_xpos := g_xpos1
}
return


; // from other macros:
; // ------------------
; 
; FormatTime, DateString, YYYYMMDDHH24MISS, yyyy_MM_dd__HH:mm
; ;MsgBox The current date is %DateString%.
; Send, %DateString%
; 


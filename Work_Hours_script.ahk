; C:\Yosi\AHK\PublicProjects.git\Working_Hours\Work_Hours_script.ahk
; This script automatically save the aggregate working hours according to user activity on his PC
; 

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

#Persistent
SetTitleMatchMode, 2
SoundBeep 500,60
MsgBox ,,, Work_Hours_script Wass reloaded ... Time: %A_Hour%:%A_Min%:%A_Sec%.,1

;
; Set variable initial (default) velues
full_screen := 0
was_active := 0
aggregate_active_min := 0
aggregate_active_hour := 0
Delta := 0
not_work_flag := 0   ; by default, when opening or reloading the script it is in: WORKING session!
aggregate_resting_min := 0
session_resting_min := 0
session_resting_hour := 0
DEBUG := 1
Version := 0.3

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
        active_min_mod60 := Mod(aggregate_active_min, 60)
        Progress,7: B cwWhite w800 c00 zh0 fs36, Aggregated time %aggregate_active_hour%:%active_min_mod60%
        ;MsgBox, PAUSE
        sleep, 2000
        Progress,7: Off
        ;MsgBox,,, Loaded params: `n hours: %aggregate_active_hour%`n minutes: %aggregate_active_min% ,3
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
  if(Delta > 400 )
  {
    Delta := 0
    was_active++
    Progress,1: OFF  ; remove resting message 
    Progress,8: OFF  ; remove view info message 
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
    sleep, 500
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

;---------------------------------------------------------------------------------------------------
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

;---------------------------------------------------------------------------------------------------
; (ctrl+shift+win+P) for "PLAYING" context...
^+#p::   ; not work session, 
  SoundBeep,600, 10
  SoundBeep,600, 10
  not_work_flag := 1
  Progress, B cwAqua w750 c00 zh0 fs36, You ars in NOT WORK session!!!
  sleep, 2500
  Progress, Off
return

;---------------------------------------------------------------------------------------------------
; so I can add (ctrl+shift+win+W) for WORKING context...
^+#v::
  Progress,8: B cwWhite w800 c00 zh0 fs36, Aggregated time: %aggregate_active_hour%H %aggregate_active_min%M `n Version: %Version%
  ;MsgBox, PAUSE
  ;Progress,7: Off
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
      session_resting_min := 0
  
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
      ;; reset the resting counter on each activity.
      Gosub, ResetResting
      
      ; send current time to "aggregate" file
      FormatTime, DateString, YYYYMMDDHH24MISS, yyyy_MM_dd__HH:mm
      FileAppend, %DateString%, C:\AHK\Aggregate_working_Hours.txt
      FileAppend, " agg min: ", C:\AHK\Aggregate_working_Hours.txt
      FileAppend, %aggregate_active_min%, C:\AHK\Aggregate_working_Hours.txt
      ; change persistant file
      IniWrite, %aggregate_active_min%, C:\AHK\work_hour_params.txt, AGGREGATE_MIN, aggregate_active_min
      if( aggregate_active_hour = 0 ){
        ; 2019_07_21 bug fixed: param file exist without AGGREGATE_HOUR Section
        IniWrite, %aggregate_active_hour%, C:\AHK\work_hour_params.txt, AGGREGATE_HOUR, aggregate_active_hour
      }
      
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
    session_resting_min += 5
    if( Mod(aggregate_resting_min, 60) = 0 ){
      aggregate_resting_hour++
      aggregate_resting_min = 0
    }
    if( session_resting_min = 60 )
    {
      session_resting_hour++
      session_resting_min = 0
    }
    ;resting_min_mod60 := Mod(aggregate_resting_min, 60)
    ;Progress,1: B cwWhite y10 w800 c00 zh0 fs36, Resting time: %aggregate_resting_hour%:%aggregate_resting_min%
    if( session_resting_min < 10 )
    {
      Progress,1: B cwWhite y10 w800 c00 zh0 fs36, Resting time: %session_resting_hour%:0%session_resting_min%
    }else{
      Progress,1: B cwWhite y10 w800 c00 zh0 fs36, Resting time: %session_resting_hour%:%session_resting_min%
    }
      if( DEBUG = 1 ){
        if( session_resting_hour = 0 ){
            string4 = "session Resting time" %session_resting_min% "minutes" %session_resting_min% "minutes" 
        }else{
          if( session_resting_hour = 1 ){
            string4 = "session Resting time" "one hour and " %session_resting_min% "minutes" 
          }else{
            string4 = "session Resting time" %session_resting_hour% "hours, and" %session_resting_min% "minutes" 
          }
        }
        ComObjCreate("SAPI.SpVoice").Speak(string4)
      }
  }
  SetTimer, tooltip_on_Timer, 3000
  a_last_YDay := A_YDay
  ; save the day
  IniWrite, %a_last_YDay%, C:\AHK\work_hour_params.txt, SISSION_DAY, a_last_YDay

}
return

ResetResting:
{
  aggregate_resting_min := 0 ; reset the resting counter on each activity.
  session_resting_min := 0
  session_resting_hour := 0
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


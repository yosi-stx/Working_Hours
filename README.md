# Working_Hours
Automatically save the aggregate working hours according to user activity on his PC


# Installation
If you've already installed AutoHotKey, just open Work_Hours_script.ahk with AutoHotkey.
You can also use Work_Hours_script.exe, which can work standalone w/o AutoHotKey.

Create AHK empty folder under your C:\ drive
e.g.
C:\AHK\

# usage
The aggregated working hours will be saved in a file:
C:\AHK\Aggregate_working_Hours.txt

By default after running the script, you are in "WORKING session"
hence the application will start aggregate the activity as working hours.

Playing:
Non working activity on the PC is considered as "PLAYING session"
in this mode there is no working hours aggregation.
To switch to "PLAYING session" use the hotkey combination:
Ctrl+Shift+Win+P

Working:
To switch back to "WORKING session" use the hotkey combination:
Ctrl+Shift+Win+W

Viewing
To view the current context:
Alt+Win+Enter

## Available commands 
|Key/Commands|Function|
|:----------:|:-------|
|Ctrl+Shift+Win+W| Enter Normal Mode. (WORKING context)|
|Ctrl+Shift+Win+P| Enter Alternative Mode. ("PLAYING" context)|
|alt+win+Enter| View the current context|
|Ctrl+Shift+Win+V| View information (message removed when mouse move)|

# default condition
By default, when opening or reloading the script it is in: WORKING session!
A small Red or Green Icon will be on the top left corner of the screen according to working state.

## Version
V_1.0 - update the executable file.
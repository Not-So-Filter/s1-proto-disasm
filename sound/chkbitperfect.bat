@echo OFF

REM // build the ROM
call build

REM  // run fc against a Sonic 1 Prototype Z80 Driver
echo -------------------------------------------------------------
if exist z80built.bin ( fc /b z80built.bin z80.bin
) else echo z80built.bin does not exist, probably due to an assembly error

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause

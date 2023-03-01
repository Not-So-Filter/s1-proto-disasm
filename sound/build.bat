@echo off

IF EXIST z80built.bin move /Y z80built.bin z80built.prev.bin >NUL

set USEANSI=n
build_tools\asw -c -t 3 -L -A -xx z80.asm
build_tools\p2bin z80.p z80built.bin -r 0x-0x

del z80.p
del z80.h
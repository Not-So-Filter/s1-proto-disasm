@echo off

:: Backup both binaries.
IF EXIST sound\z80built.bin move /Y sound\z80built.bin sound\z80built.prev.bin >NUL
IF EXIST s1built.bin move /Y s1built.bin s1built.prev.bin >NUL

:: Before anything, we build the z80 binary blob first.
set USEANSI=n
build_tools\asl -q -L -A -E -xx sound\z80.asm
build_tools\p2bin sound\z80.p sound\z80built.bin -r 0x-0x

del sound\z80.p

asm68k /k /p /o ae-,c+,l. sonic.asm, s1built.bin, , sonic.lst > log.txt
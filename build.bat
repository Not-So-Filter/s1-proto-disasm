@echo off

IF EXIST s1built.bin move /Y s1built.bin s1built.prev.bin >NUL
asm68k.exe /k /p /o ae-,c+,l. sonic.asm, s1built.bin, , sonic.lst > log.txt
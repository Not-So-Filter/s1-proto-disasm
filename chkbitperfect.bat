@echo off

echo Checking Built Z80 with Original Z80...
IF EXIST sound\z80built.bin ( fc /b sound\z80built.bin sound\z80.bin 
)else echo z80built.bin does not exist.

pause
cls

echo Checking Built ROM with Original ROM...
IF EXIST s1built.bin ( fc /b s1built.bin s1.proto.bin 
)else echo s1built.bin does not exist.

pause

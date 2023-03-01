@echo off

echo Checking Built ROM with Original ROM...
IF EXIST s1built.bin ( fc /b s1built.bin s1.proto.bin 
)else echo s1built.bin does not exist.

pause

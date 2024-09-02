@echo off

IF EXIST s1built.bin move /Y s1built.bin s1built.prev.bin >NUL

build_tools\asw -xx -q -A -L -U -E -i . sonic.asm
build_tools\p2bin -p=FF -z=0 sonic.p s1built.bin

del sonic.p
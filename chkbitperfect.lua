#!/usr/bin/env lua

local clownmd5 = require "build_tools.lua.clownmd5"

-- Prevent build.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Build the ROM.
local co = coroutine.create(function() dofile("build.lua") end)
local _, _, abort = assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

if not abort then
	-- Hash the ROM.
	local hash = clownmd5.HashFile("s1built.bin")

	-- Verify the hash against build.
	print "-------------------------------------------------------------"

	if hash == "\xB0\x65\x78\xC3\x41\x2D\xE1\xC5\xBE\x76\x5A\x59\xDE\xC5\xFF\x1F" then
		print "ROM is bit-perfect with Prototype."
	else
		print "ROM is NOT bit-perfect with Prototype!"
	end
end

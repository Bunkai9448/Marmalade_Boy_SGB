#!/bin/bash

# ASM=ExpandedROM_BankTest.asm
ASM=ExpandedROMnewScript.asm

# Delete previous test copies to avoid confusion
if [ -f "$output.gb" ];
 then rm "$output.gb"
fi

# Create a new test copy to work with
cp "MarmaladeBoy.gb" "output.gb"

echo Compiling $ASM and Injecting the changes ...
eval "./armips $ASM"

# Test Changes
GAME_ROM="output.gb"
echo Executing sdl2gnuboy_emu to play "$GAME_ROM"!

printf '\nControls (Keyboard)
---------------
ESC - QUIT 
W - UP
S - DOWN
A - LEFT 
D - RIGHT 
Q - A
E - B
ENTER - START
X - SELECT
---------------
More info at https://github.com/AlexOberhofer/SDL2-GNUBoy/ \n\n'

eval ../sdl2gnuboy_emu "$GAME_ROM"

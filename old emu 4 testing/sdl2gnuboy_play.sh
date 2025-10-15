#!/bin/bash

GAME_ROM="marmalade.gb"

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

./sdl2gnuboy_emu "$GAME_ROM"

printf 'Exiting emu ...\n'
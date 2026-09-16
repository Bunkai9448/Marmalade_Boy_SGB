#!/usr/bin/env python3

import sys
import subprocess
import os
import shutil

from Text_Extraction_Insertion.Font_GFX import insert_bytes

# This script as a whole being python should work in Windows and Unix Systems.
# However, for the ASM patches it requires a different executable for each system
# This little snippets is done to make that almost transparent for the user. Just need to set the variables accordingly.
# A blank name "" will make the script jump over that command, this is done so you can re-run things separately for tests

ROM="rom.gb"

FONT="Text_Extraction_Insertion/Font.bin"         # The new Font Tiles
EXP_ROUTINE=""  # The ROM expansion and header fixes (this is replicated in all ASM and has no single asm for it. Leaving here for completeness)
DISP_ROUTINE="ASM/Working_Text_Hook_paired.asm"        # The new Font Size Display
EXPAND_POINTERS="ASM/ExpandedROMnewScript.asm"     # The Pointers are now located in expanded ROM addresses

IS_WINDOWS = True

if IS_WINDOWS:
    ARMIPS = "ASM/armips_at_gameboy.exe"
else:
    ARMIPS = "./ASM/armips_at_gameboy-unix"

def _create_backup():

    if not os.path.exists("backup_rom.gb"):
        shutil.copy2(ROM, "backup_rom.gb")

def _run_command(command):
    print("> " + " ".join(command)) # The tool will be verbose, so the user knows when the key sections are running.
    result = subprocess.run(command)

    if result.returncode != 0:
        print(
            f"ERROR: command failed with exit code "
            f"{result.returncode}"
        )
        sys.exit(result.returncode)



if __name__ == "__main__":

# When Python is run as external command (instead of them as libs) so I can keep testing things separately without forgetting what was the name of each def.
# You can change it to go one by one, to do it more cleanly.

    _create_backup()

    if FONT:
        insert_bytes("backup_rom.gb", FONT, ROM, 0x33900)

    if EXP_ROUTINE:
        _run_command([ARMIPS, EXP_ROUTINE])

    if DISP_ROUTINE:
        _run_command([ARMIPS, DISP_ROUTINE])

    if EXPAND_POINTERS:
        _run_command([ARMIPS, EXPAND_POINTERS])


    print("All ASM patches have been applied successfuly")

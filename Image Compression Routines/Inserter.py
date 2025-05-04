import shutil

def insert_hex_data_into_rom(rom_path, new_rom_path, hex_files):
    # Copy the original file to a new one
    shutil.copy(rom_path, new_rom_path)

    with open(new_rom_path, 'r+b') as rom:
        for hex_file in hex_files:
            # Extract the offset of the file name, after the prefix 'c_'
            offset_str = hex_file.split('_')[1].split('.')[0]
            offset = int(offset_str, 16)

            # Read hexadecimal data from binary file
            with open(hex_file, 'rb') as hf:
                hex_data = hf.read()

            # Go to the offset and read the ROM file from there
            rom.seek(offset)
            rom_data = rom.read()

            # Determine the end of the available space, avoiding sequences 99EE
            end_offset = -1
            i = 0
            while i < len(rom_data):
                if rom_data[i] == 0xEE:
                    # Verify if it is 99EE
                    if i > 0 and rom_data[i-1] == 0x99:
                        i += 1  # Skip and continue searching
                        continue
                    else:
                        end_offset = i + offset
                        break
                i += 1

            if end_offset == -1:
                print(f"Error: Byte 'EE' not found after offset {hex(offset)}.")
                continue

            # The offset 0x36A1B, ends 'FF' so it needs 0x19F bytes
            if offset == 0x36A1B:
                end_offset = offset + 0x19F

            # Verify if the hexadecimal data fits in the space available
            available_space = end_offset - offset+1
            if len(hex_data) > available_space:
                print(f"Error: File data {hex_file} ({len(hex_data)} bytes) are larger than ({available_space} bytes).")
            else:
                # Insert data in the designated space
                rom.seek(offset)
                rom.write(hex_data)
                print(f"Success: {hex_file} ({len(hex_data)} bytes) was correctly inserted in the offset {hex(offset)}. Available space: {available_space} bytes.")

# List of hexadecimal files
hex_files = [
    'c_0x1C9FA.bin', 'c_0x1E7CC.bin', 'c_0x2401A.bin', 'c_0x246C0.bin',
    'c_0x25280.bin', 'c_0x256B4.bin', 'c_0x257BB.bin', 'c_0x25DE8.bin',
    'c_0x2979B.bin', 'c_0x2EF8E.bin', 'c_0x307F1.bin', 'c_0x31A8F.bin',
    'c_0x31F11.bin', 'c_0x32854.bin', 'c_0x332F6.bin', 'c_0x356E2.bin',
    'c_0x36A1B.bin'
]

# Path of the original file and the new file
rom_path = 'Marmalade Boy.gb'
new_rom_path = 'Marmalade Boy_Pics.gb'

# Insert hexadecimal data into the new ROM
insert_hex_data_into_rom(rom_path, new_rom_path, hex_files)

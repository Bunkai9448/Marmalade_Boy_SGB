def read_rom(rom_path, offset):
    with open(rom_path, 'rb') as f:
        f.seek(offset)
        data = []
        while True:
            byte1 = f.read(1)
            if not byte1:
                break  # Stop at end of file
            
            data.append(byte1[0])

            if byte1[0] == 0x00:
                byte2 = f.read(1)
                if not byte2:
                    break  # Stop at end of file

                if byte2[0] == 0xEE:
                    break  # Stop on "00EE"
                
                data.append(byte2[0])
                
        return data
  
# Decompression function similar to the assembler routine
def decompress(data):
    output = []
    i = 0
    while i < len(data):
        byte = data[i]
        i += 1
        if byte == 0xBB:
            count = data[i]
            i += 1
            output.extend([0x00] * count)
        elif byte == 0xCC:
            count = data[i]
            i += 1
            output.extend([0xFF] * count)
        elif byte == 0xDD:
            value = data[i]
            i += 1
            count = data[i]
            i += 1
            output.extend([value] * count)
        elif byte == 0xAA:
            count = data[i]
            i += 1
            value1 = data[i]
            i += 1
            value2 = data[i]
            i += 1
            output.extend([value1, value2] * count)
        elif byte == 0xEE:
            break
        elif byte == 0x99:
            value = data[i]
            i += 1
            output.append(value)
        else:
            output.append(byte)
    return output

# Function to save the decompressed data in a .bin file
def save_to_bin(data, output_path):
    with open(output_path, 'wb') as f:
        f.write(bytearray(data))

# Path to ROM
rom_path = 'Marmalade Boy.gb'

# List of offsets from which compressed data is taken
offsets = [
    0x1C9FA,
    0x1E7CC,
    0x21B00, # (END) psychology test results
    0x246C0,
    0x2979B,
    0x2EF8E,
    0x307F1,
    0x31A8F, 
    0x31F11,
    0x3232D, # Notebook's 1st page
    0x32854, # Notebook's Item, How to use, Marmalade
    0x332F6,
    0x356E2, # 光希遊のへや玄関
    0x36A1B, # E正面玄関
    0x2401A, # Main (Start) Screen
    0x25280, # 銀太のテニスマッチ遊の　メダイュの秘密恋の行方
    0x256B4,
    0x257BB, # Copyright screen
    0x25DE8 # Password Robot
]

# Process each offset
for offset in offsets:
    try:
        # Read compressed ROM data
        compressed_data = read_rom(rom_path, offset)
        
        # Decompress data
        decompressed_data = decompress(compressed_data)
        
        # Create output file name based on offset
        output_bin_path = f"0x{offset:X}.bin"
        
        # Save the decompressed data in a .bin file
        save_to_bin(decompressed_data, output_bin_path)
        
        print(f"Uncompressed data stored in: {output_bin_path}")
    except Exception as e:
        print(f"Error in offset 0x{offset:X}: {e}")
        
print('Decompression process completed.')

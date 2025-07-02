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
    0x1803E,  # Meiko animation
    0x1880E,  # Yuu animation
    0x18F63,  # Arimi animation
    0x196DA,  # Ginta animation
    0x1A0C1,  # Rokutanda animation
    0x1A4E3,  # Miwa animation
    0x1AFCE,  # 銀太との遊相性格　性診断のテスト
    0x1BC08,  # Keyword 1/9 for SFC game
    0x1BCEA,  # Keyword 2/9 for SFC game
    0x1BDBB,  # Keyword 3/9 for SFC game
    0x1C9FA,  # Ginta at the phone
    0x1E7CC,  # Miki at the phone
    0x20DA1,  # One Point Advice
    0x21B00,  # (END) psychology test results - 1
    0x221AF,  # (END) psychology test results - 2
    0x22672,  # (END) psychology test results - 3
    0x229CD,  # (END) psychology test results - 4
    0x2401A,  # Main (Start) Screen
    0x246C0,  # Triangles from intro screen
    0x25280,  # 銀太のテニスマッチ遊の　メダイュの秘密恋の行方
    0x257BB,  # Copyright screen
    0x25DE8,  # Password Robot
    0x27FE8,  # Highschool outside - review offset
    0x2979B,  # Tennis court
    0x2F1E8,  # Miki face 
    0x30967,  # Background for heart drawing minigame
    0x31500,  # sprites for cookies and piano minigames - 1
    0x31700,  # sprites for cookies and piano minigames - 2
    0x31F11,  # sprites for coin minigame
    0x3232D,  # Notebook's 1st page
    0x32854,  # Notebook's Item, How to use, Marmalade
    0x332F6,  # Candy sprite
    0x356E2,  # 光希遊のへや玄関
    0x36A1B,  # E正面玄関
    0x37BF0   # キャラメル　バンダイ　PUSH A BUTTON
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

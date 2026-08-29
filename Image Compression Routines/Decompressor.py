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
    0x19DD9, # Rokutanda Face
    0x1A4E3, 
    0x1AD85, 
    0x1AFCE, # Psychology test titles (START) 
    0x1B4B8, # Keyword 01
    0x1B5BA, # Keyword 02
    0x1B7C2, # Keyword 03
    0x1B93F, # Keyword 04
    0x1B678, # Keyword 05
    0x1BA2D, # Keyword 06
    0x1BB42, # Keyword 07
    0x1BC07, # Keyword 08
    0x1BCEA, # Keyword 09
    0x1BDBB, # Keyword 10
    0x1BE7D, # Katakana font section, similar to the ones used in the password system
    0x1C9FA,
    0x1D855, # Miki shocked screen
    0x1E7CC,
    0x1EFD9, # 2nd Font (hiragana only) and Push a button text
    0x1F66E, # two sentences, each one describes why she likes each boy
    0x1F845, # Ginta and Yuu faces
    0x20DA1, # Marmalade Boy text from Pro tip screen
    0x21624, # Robot 
    0x218E5, # dates and blood type font
    0x21AFE, # Tiles for 1st image in psychology results
    0x21B00, # (END) psychology test results
    0x22188, # 恋診断書の
    0x22672, # 
    0x229CD, # Psychology Graphic scale and each vortix legend
    0x22D5A, # "keyword" Test
    0x23652, # Password text
    0x23973, # 
    0x23F0E, # Main screen, needs aligment (I should have this one from the first tests)
    0x2401A, # Main (Start) Screen
    0x246C0,
    0x24BA8, # School Logo and "Marmalade Boy Smash" text
    0x25280, # 銀太のテニスマッチ遊の　メダイュの秘密恋の行方
    0x256B4,
    0x257BB, # Copyright screen
    0x25DE8, # Password Robot
    0x265A1, # Ginta Face
    0x28B8E, # Library background tiles
    0x2979B,
    0x2DF04, # "Hand Made" Sign from a background shop
    0x2E9C6,
    0x2EF8E,
    0x2F1E8, # Miki Face
    0x2F64B, # Maruten and Handakuten tiles, follows 2nd font stuff in vram
    0x2F855, # Yuu Face
    0x302C6, # Candy Jar with candies in it for the minigame
    0x3059C, # Numbers and faces for that jar minigame
    0x307F1,
    0x30967, # 
    0x31374,
    0x317C1, # Piano Minigame, "Replay" and "Play" Buttons and its label
    0x31A8F,
    0x31AD9, # Coin Minigame background with "Marmalade Boy" text
    0x31F11,
    0x3232D, # Notebook's 1st page
    0x32854, # Notebook's Item, How to use, Marmalade
    0x332F6,
    0x35065, # リビングキッチン
    0x356E2, # 光希遊のへや玄関
    0x35BBE, # 校　図書館　中庭 needs aligment
    0x361AF, # テニスコート
    0x3639D, # 教室　建ＡＢＣＤ
    0x36A1B, # E正面玄関
    0x36EAF, # 映画館公園並木通
    0x3761F, # 
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

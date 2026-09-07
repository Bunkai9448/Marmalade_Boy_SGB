import json

def compress(input_data):
    compressed = bytearray()
    i = 0
    while i < len(input_data):
        # Search for repeated sequences
        if i + 1 < len(input_data):
            count = 1
            while i + count < len(input_data) and input_data[i] == input_data[i + count]:
                count += 1
            if count >= 3:
                # Sequence of repeated bytes
                count_hex = count & 0xFF
                
                if input_data[i] == 0x00:
                    compressed.extend([0xBB, count_hex])
                elif input_data[i] == 0xFF:
                    compressed.extend([0xCC, count_hex])
                else:
                    compressed.extend([0xDD, input_data[i], count_hex])
                i += count
                continue

        # Search for repeated byte pairs
        if i + 3 < len(input_data):
            count = 1
            while i + count * 2 + 1 < len(input_data) and input_data[i:i+2] == input_data[i+count*2:i+count*2+2]:
                count += 1
            if count > 2:
                compressed.extend([0xAA, count, input_data[i], input_data[i+1]])
                i += count * 2
                continue

        # Single byte
        if input_data[i] in [0xBB, 0xCC, 0xDD, 0xAA, 0x99, 0xEE]:
            compressed.extend([0x99, input_data[i]])
        else:
            compressed.append(input_data[i])
        i += 1

    compressed.append(0xEE)  # End data
    return compressed

# List of files to compress
files_to_compress = [
    0x1803E,
    0x1880E,
    0x18F63,
    0x196DA,
    0x19DD9, # Rokutanda Face
    0x1A4E3,
    0x1ABF5,
    0x1ABF6,
    0x1ABFE,
    0x1AC13,
    0x1ACAA,
    0x1AD85,
    0x1AF47,
    0x1AFC1,
    0x1AFCE, # Psychology test titles (START)
    0x1B3FB,
    0x1B4B8, # Keyword 01
    0x1B5BA, # Keyword 02
    0x1B678, # Keyword 05
    0x1B7C2, # Keyword 03
    0x1B93F, # Keyword 04
    0x1BA2D, # Keyword 06
    0x1BB42, # Keyword 07
    0x1BC07, # Keyword 08
    0x1BCEA, # Keyword 09
    0x1BDBB, # Keyword 10
    0x1BE7D, # Katakana font section, similar to the ones used in the password system
    0x1BEE2,
    0x1C040,
    0x1C18E,
    0x1C1C1,
    0x1C365,
    0x1C4EF,
    0x1C78E,
    0x1C9FA,
    0x1CC33,
    0x1CCBE,
    0x1CCD9,
    0x1CD4B,
    0x1CE15,
    0x1CE88,
    0x1D38A,
    0x1D457,
    0x1D668,
    0x1D855, # Miki shocked screen
    0x1DC09,
    0x1DC48,
    0x1DE30,
    0x1E017,
    0x1E212,
    0x1E3EB,
    0x1E5E1,
    0x1E7CC,
    0x1E9B8,
    0x1EFD9, # 2nd Font (hiragana only) and Push a button text
    0x1F467,
    0x1F579,
    0x1F66E, # two sentences, each one describes why she likes each boy
    0x1F845, # Ginta and Yuu faces
    0x1FDC5,
    0x20000,
    0x20036,
    0x2070C,
    0x20DA1, # Marmalade Boy text from Pro tip screen
    0x214CF,
    0x2156C,
    0x21624, # Robot
    0x21865,
    0x218E5, # dates and blood type font
    0x21AFE, # Tiles for 1st image in psychology results
    0x21B00, # (END) psychology test results
    0x22188, # 恋診断書の
    0x22672, # 
    0x229CD, # Psychology Graphic scale and each vortix legend
    0x22D5A, # "keyword" Test
    0x22F30,
    0x23081,
    0x23172,
    0x232D0,
    0x233F0,
    0x23652, # Password text
    0x23828,
    0x238BA,
    0x238DE,
    0x2391E,
    0x23942,
    0x23973, # 
    0x23F0E, # Main screen, needs aligment (I should have this one from the first tests)
    0x2401A, # Main (Start) Screen
    0x246C0,
    0x2498C,
    0x24A61,
    0x24BA8, # School Logo and "Marmalade Boy Smash" text
    0x25280, # 銀太のテニスマッチ遊の　メダイュの秘密恋の行方
    0x256B4,
    0x257BB, # Copyright screen
    0x25D14,
    0x25DE8, # Password Robot
    0x2638D,
    0x264CB,
    0x264FC,
    0x265A1, # Ginta Face
    0x28018,
    0x2862D,
    0x28B8E, # Library background tiles
    0x290E6,
    0x2979B,
    0x29E84,
    0x2A2BD,
    0x2AA31,
    0x2AD1D,
    0x2B3B5,
    0x2B992,
    0x2BE83,
    0x2C046,
    0x2C128,
    0x2C1FF,
    0x2C2EC,
    0x2C3BF,
    0x2C49E,
    0x2C579,
    0x2C615,
    0x2C6C7,
    0x2C799,
    0x2C886,
    0x2C950,
    0x2CA12,
    0x2CB05,
    0x2CBBF,
    0x2CC8C,
    0x2CD7D,
    0x2CE27,
    0x2CEFF,
    0x2CFB8,
    0x2D578,
    0x2D8FA,
    0x2DF04, # "Hand Made" Sign from a background shop
    0x2E441,
    0x2E7EC,
    0x2E9C6,
    0x2EF8E,
    0x2F1E8, # Miki Face
    0x2F64B, # Maruten and Handakuten tiles, follows 2nd font stuff in vram
    0x2F855, # Yuu Face
    0x2FC33,
    0x2FCDE,
    0x2FD90,
    0x2FE35,
    0x2FF09,
    0x30000,
    0x30050,
    0x300EB,
    0x301E5,
    0x302C6, # Candy Jar with candies in it for the minigame
    0x3059C, # Numbers and faces for that jar minigame
    0x307F1,
    0x308CC,
    0x30967, # 
    0x30CFE,
    0x31242,
    0x31374,
    0x317C1, # Piano Minigame, "Replay" and "Play" Buttons and its label
    0x31A8F,
    0x31AD9, # Coin Minigame background with "Marmalade Boy" text
    0x31F11,
    0x32022,
    0x32160,
    0x3232D, # Notebook's 1st page
    0x32854, # Notebook's Item, How to use, Marmalade
    0x32B1A,
    0x32CB8,
    0x32DD9,
    0x32ECE,
    0x32FF3,
    0x33136,
    0x3325F,
    0x33262,
    0x332F6,
    0x3334B,
    0x333C4,
    0x3343D,
    0x334A5,
    0x33517,
    0x3360F,
    0x33707,
    0x34000,
    0x3404C,
    0x340DD,
    0x344BA,
    0x34675,
    0x347D9,
    0x34945,
    0x34979,
    0x349BB,
    0x349F8,
    0x34A33,
    0x34A68,
    0x34AA9,
    0x34B4E,
    0x34BE6,
    0x34C8A,
    0x34CC1,
    0x34D25,
    0x34D67,
    0x34DCA,
    0x34E35,
    0x34E94,
    0x35065, # リビングキッチン
    0x356E2, # 光希遊のへや玄関
    0x35998,
    0x35AA0,
    0x35ABB,
    0x35BBE, # 校　図書館　中庭 needs aligment
    0x361AF, # テニスコート
    0x362A3,
    0x3639D, # 教室　建ＡＢＣＤ
    0x36A1B, # E正面玄関
    0x36B5C,
    0x36EAF, # 映画館公園並木通
    0x3761F, # 
    0x37986,
    0x37AD9,
    0x37BD6,
]

# Original compressed sizes to check against, from Decompressor.py's
# bin_sizes.json -- compressed_size there is the true space (including the
# terminator byte) each block occupied at its offset in the ROM, so a
# recompressed file bigger than that would overwrite whatever follows.
SIZE_REPORT_PATH = 'bin_sizes.json'
try:
    with open(SIZE_REPORT_PATH, 'r') as f:
        size_report = json.load(f)
except FileNotFoundError:
    print(f"Warning: {SIZE_REPORT_PATH} not found -- size checking will be "
          f"skipped for all files. Run the updated Decompressor.py first to "
          f"generate it.")
    size_report = {}

# Compress each file
for file_name in files_to_compress:
    try:
        with open(file_name, 'rb') as f:
            input_data = f.read()
        
        compressed_data = compress(input_data)
        
        output_file_name = f'c_{file_name}'
        with open(output_file_name, 'wb') as f:
            f.write(compressed_data)

        new_size = len(compressed_data)
        print(f'File {file_name} successfully compressed as {output_file_name} ({new_size} bytes)')

        # offset_key: "0x2401A.bin" -> "0x2401A", matching bin_sizes.json's keys
        offset_key = file_name[:-4] if file_name.endswith('.bin') else file_name
        original_info = size_report.get(offset_key)
        if original_info is None:
            print(f'  (no original size on record for {offset_key} in '
                  f'{SIZE_REPORT_PATH} -- skipped size check)')
        else:
            original_size = original_info.get('compressed_size')
            if new_size <= original_size:
                spare = original_size - new_size
                print(f'  FITS: {new_size} <= {original_size} bytes (original) '
                      f'-- {spare} byte(s) to spare, safe to reinsert in place')
            else:
                over = new_size - original_size
                print(f'  DOES NOT FIT: {new_size} > {original_size} bytes '
                      f'(original) -- {over} byte(s) over, would overwrite '
                      f'whatever follows at that offset in the ROM')

    except FileNotFoundError:
        print(f'Error: Could not find the file {file_name}')
    except Exception as e:
        print(f'Error when compressing {file_name}: {str(e)}')

print('Compression process completed.')

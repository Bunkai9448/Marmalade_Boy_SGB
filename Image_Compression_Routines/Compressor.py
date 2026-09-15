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
    '0x1803E.bin',
    '0x1880E.bin',
    '0x18F63.bin',
    '0x196DA.bin',
    '0x19DD9.bin',  # Rokutanda Face
    '0x1A4E3.bin',
    '0x1ABF5.bin',
    '0x1ABF6.bin',
    '0x1ABFE.bin',
    '0x1AC13.bin',
    '0x1ACAA.bin',
    '0x1AD85.bin',
    '0x1AF47.bin',
    '0x1AFC1.bin',
    '0x1AFCE.bin',  # Psychology test titles (START)
    '0x1B3FB.bin',
    '0x1B4B8.bin',  # Keyword 01
    '0x1B5BA.bin',  # Keyword 02
    '0x1B678.bin',  # Keyword 05
    '0x1B7C2.bin',  # Keyword 03
    '0x1B93F.bin',  # Keyword 04
    '0x1BA2D.bin',  # Keyword 06
    '0x1BB42.bin',  # Keyword 07
    '0x1BC07.bin',  # Keyword 08
    '0x1BCEA.bin',  # Keyword 09
    '0x1BDBB.bin',  # Keyword 10
    '0x1BE7D.bin',  # Katakana font section
    '0x1BEE2.bin',
    '0x1C040.bin',
    '0x1C18E.bin',
    '0x1C1C1.bin',
    '0x1C365.bin',
    '0x1C4EF.bin',
    '0x1C78E.bin',
    '0x1C9FA.bin',
    '0x1CC33.bin',
    '0x1CCBE.bin',
    '0x1CCD9.bin',
    '0x1CD4B.bin',
    '0x1CE15.bin',
    '0x1CE88.bin',
    '0x1D38A.bin',
    '0x1D457.bin',
    '0x1D668.bin',
    '0x1D855.bin',  # Miki shocked screen
    '0x1DC09.bin',
    '0x1DC48.bin',
    '0x1DE30.bin',
    '0x1E017.bin',
    '0x1E212.bin',
    '0x1E3EB.bin',
    '0x1E5E1.bin',
    '0x1E7CC.bin',
    '0x1E9B8.bin',
    '0x1EFD9.bin',  # 2nd Font (hiragana only) and Push a button text
    '0x1F467.bin',
    '0x1F579.bin',
    '0x1F66E.bin',  # two sentences
    '0x1F845.bin',  # Ginta and Yuu faces
    '0x1FDC5.bin',
    '0x20000.bin',
    '0x20036.bin',
    '0x2070C.bin',
    '0x20DA1.bin',  # Marmalade Boy text from Pro tip screen
    '0x214CF.bin',
    '0x2156C.bin',
    '0x21624.bin',  # Robot
    '0x21865.bin',
    '0x218E5.bin',  # dates and blood type font
    '0x21AFE.bin',  # Tiles for 1st image in psychology results
    '0x21B00.bin',  # (END) psychology test results
    '0x22188.bin',
    '0x22672.bin',
    '0x229CD.bin',  # Psychology Graphic scale
    '0x22D5A.bin',  # "keyword" Test
    '0x22F30.bin',
    '0x23081.bin',
    '0x23172.bin',
    '0x232D0.bin',
    '0x233F0.bin',
    '0x23652.bin',  # Password text
    '0x23828.bin',
    '0x238BA.bin',
    '0x238DE.bin',
    '0x2391E.bin',
    '0x23942.bin',
    '0x23973.bin',
    '0x23F0E.bin',
    '0x2401A.bin',  # Main (Start) Screen
    '0x246C0.bin',
    '0x2498C.bin',
    '0x24A61.bin',  # title tilemap
    '0x24BA8.bin',  # School Logo and "Marmalade Boy Smash" text
    '0x25280.bin',
    '0x256B4.bin',
    '0x257BB.bin',  # Copyright screen
    '0x25D14.bin',
    '0x25DE8.bin',  # Password Robot
    '0x2638D.bin',
    '0x264CB.bin',
    '0x264FC.bin',
    '0x265A1.bin',  # Ginta Face
    '0x28018.bin',
    '0x2862D.bin',
    '0x28B8E.bin',  # Library background tiles
    '0x290E6.bin',
    '0x2979B.bin',
    '0x29E84.bin',
    '0x2A2BD.bin',
    '0x2AA31.bin',
    '0x2AD1D.bin',
    '0x2B3B5.bin',
    '0x2B992.bin',
    '0x2BE83.bin',
    '0x2C046.bin',
    '0x2C128.bin',
    '0x2C1FF.bin',
    '0x2C2EC.bin',
    '0x2C3BF.bin',
    '0x2C49E.bin',
    '0x2C579.bin',
    '0x2C615.bin',
    '0x2C6C7.bin',
    '0x2C799.bin',
    '0x2C886.bin',
    '0x2C950.bin',
    '0x2CA12.bin',
    '0x2CB05.bin',
    '0x2CBBF.bin',
    '0x2CC8C.bin',
    '0x2CD7D.bin',
    '0x2CE27.bin',
    '0x2CEFF.bin',
    '0x2CFB8.bin',
    '0x2D578.bin',
    '0x2D8FA.bin',
    '0x2DF04.bin',
    '0x2E441.bin',
    '0x2E7EC.bin',
    '0x2E9C6.bin',
    '0x2EF8E.bin',
    '0x2F1E8.bin',  # Miki Face
    '0x2F64B.bin',
    '0x2F855.bin',  # Yuu Face
    '0x2FC33.bin',
    '0x2FCDE.bin',
    '0x2FD90.bin',
    '0x2FE35.bin',
    '0x2FF09.bin',
    '0x30000.bin',
    '0x30050.bin',
    '0x300EB.bin',
    '0x301E5.bin',
    '0x302C6.bin',
    '0x3059C.bin',
    '0x307F1.bin',
    '0x308CC.bin',
    '0x30967.bin',
    '0x30CFE.bin',
    '0x31242.bin',
    '0x31374.bin',
    '0x317C1.bin',
    '0x31A8F.bin',
    '0x31AD9.bin',
    '0x31F11.bin',
    '0x32022.bin',
    '0x32160.bin',
    '0x3232D.bin',
    '0x32854.bin',
    '0x32B1A.bin',
    '0x32CB8.bin',
    '0x32DD9.bin',
    '0x32ECE.bin',
    '0x32FF3.bin',
    '0x33136.bin',
    '0x3325F.bin',
    '0x33262.bin',
    '0x332F6.bin',
    '0x3334B.bin',
    '0x333C4.bin',
    '0x3343D.bin',
    '0x334A5.bin',
    '0x33517.bin',
    '0x3360F.bin',
    '0x33707.bin',
    '0x34000.bin',
    '0x3404C.bin',
    '0x340DD.bin',
    '0x344BA.bin',
    '0x34675.bin',
    '0x347D9.bin',
    '0x34945.bin',
    '0x34979.bin',
    '0x349BB.bin',
    '0x349F8.bin',
    '0x34A33.bin',
    '0x34A68.bin',
    '0x34AA9.bin',
    '0x34B4E.bin',
    '0x34BE6.bin',
    '0x34C8A.bin',
    '0x34CC1.bin',
    '0x34D25.bin',
    '0x34D67.bin',
    '0x34DCA.bin',
    '0x34E35.bin',
    '0x34E94.bin',
    '0x35065.bin',
    '0x356E2.bin',
    '0x35998.bin',
    '0x35AA0.bin',
    '0x35ABB.bin',
    '0x35BBE.bin',
    '0x361AF.bin',
    '0x362A3.bin',
    '0x3639D.bin',
    '0x36A1B.bin',
    '0x36B5C.bin',
    '0x36EAF.bin',
    '0x3761F.bin',
    '0x37986.bin',
    '0x37AD9.bin',
    '0x37BD6.bin',
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

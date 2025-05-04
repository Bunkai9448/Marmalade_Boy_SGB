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
    '0x1C9FA.bin',
    '0x1E7CC.bin',
    '0x2401A.bin',
    '0x246C0.bin',
    '0x25280.bin',
    '0x256B4.bin',
    '0x257BB.bin',
    '0x25DE8.bin',    
    '0x2979B.bin',
    '0x2EF8E.bin',
    '0x307F1.bin',
    '0x31A8F.bin',
    '0x31F11.bin',
    '0x32854.bin',
    '0x332F6.bin',
    '0x356E2.bin',
    '0x36A1B.bin',
]

# Compress each file
for file_name in files_to_compress:
    try:
        with open(file_name, 'rb') as f:
            input_data = f.read()
        
        compressed_data = compress(input_data)
        
        output_file_name = f'c_{file_name}'
        with open(output_file_name, 'wb') as f:
            f.write(compressed_data)
        
        print(f'File {file_name} successfully compressed as {output_file_name}')
    except FileNotFoundError:
        print(f'Error: Could not find the file {file_name}')
    except Exception as e:
        print(f'Error when compressing {file_name}: {str(e)}')

print('Compression process completed.')

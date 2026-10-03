import struct
import os
from pathlib import Path
import re

CONFIG_INSERT = {
    "rom_file_path": "output.gb",
    "output_file": "Text_Extraction_Insertion/Marmalade_script.txt",
    "pointer_table_start": 0xC000,
    "pointer_table_stop": 0xC008,
    "pointer_size": 2,
    "base_pointer": 0xC000,
    "finishing_pointer": 0xF0,
    "table_file": "Text_Extraction_Insertion/CharConverter/FontTable_SPA.tbl",
    # Debe ser identica a la del extractor para que ambos ignoren
    # los mismos pointers no-texto.
    # Criterio: apuntan fuera de rango, o no contienen <END>,
    # o son claramente basura binaria (bytes mezclados con kanji).
    # NOTA: #453 ($C38A) NO se salta porque contiene texto valido ("゛たよ!") con <END> real, aunque sea un fragmento corto.
    "skip_pointer_offsets": [
        0xC3F4,  # #506 - datos binarios (skip original)
        0xC1EC,  # #246 - basura binaria (destino $17FDF)
        0xC1EE,  # #247 - basura binaria (destino $17FFF)
        0xC388,  # #452 - basura binaria (destino $17FFF)
        0xC38C,  # #454 - fuera de rango (destino $FFFF)
        0xC4C8,  # #612 - basura binaria (destino $17FFF)
        0xC4CA,  # #613 - basura binaria (destino $17FFF)
        0xC4CC,  # #614 - basura binaria (destino $17FFB)
        0xC4CE,  # #615 - basura binaria (destino $17FFF)
        0xC5D8,  # #748 - tabla de bytes (destino $FF7F)
    ],
}


# El ASM (ExpandedROMnewScript.asm) copia el banco $03 original a
# 0x44000 (banco $11, CPU $4000). La tabla de punteros expandida
# vive ahi, y el texto nuevo se escribe a partir de 0x45000.
EXPANDED_TABLE_OFFSET = 0x44000
ORIGINAL_TABLE_OFFSET = 0xC000


def load_table(filename):
    """Load the translation table from a .tbl file and create a reverse mapping"""
    table = {}
    reverse_table = {}
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line and '=' in line and not line.startswith('#'):
                    hex_value, char = line.split('=', 1)
                    byte_value = int(hex_value, 16)
                    table[byte_value] = char
                    base_char = re.sub(r',[\d]+$', '', char)
                    reverse_table[base_char] = byte_value
    except FileNotFoundError:
        print(f"Error: Table file '{filename}' not found")
    return table, reverse_table


def parse_text_file(text_file):
    """Parse the extracted text file and return pointer offsets and their corresponding texts"""
    pointer_texts = {}

    with open(text_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    for i, line in enumerate(lines):
        line = line.strip()
        if line.startswith('#W16($'):
            pointer_offset = int(line[6:10], 16)
            text = ""
            for next_line in lines[i+1:]:
                # Solo quitamos el salto de línea, no los espacios
                next_line = next_line.rstrip('\n\r')
                stripped = next_line.strip()

                # Nueva entrada: paramos
                if stripped.startswith('#W16($') or stripped.startswith('//POINTER'):
                    break

                # Línea vacía: es separador interno (párrafo), no fin
                if stripped == "":
                    continue

                text += next_line

            if text:
                pointer_texts[pointer_offset] = text

    return pointer_texts


def text_to_bytes(text, reverse_table, finishing_pointer):
    """Convert text back to bytes using the reverse translation table"""
    # Los espacios literales del .txt se representan como <SP> en la tabla.
    text = text.replace(' ', '<SP>')

    bytes_data = bytearray()
    i = 0

    while i < len(text):
        if text[i] == '<' and '>' in text[i:]:
            end_idx = text.index('>', i)
            control_code = text[i:end_idx + 1]

            if control_code == '<DICT_TABLE>':
                bytes_data.append(reverse_table['<DICT_TABLE>'])
                i += len('<DICT_TABLE>')
            elif control_code.startswith('<$') and len(control_code) == 5:
                byte_val = int(control_code[2:4], 16)
                bytes_data.append(byte_val)
                i += 5
            elif control_code == '<NL>':
                bytes_data.append(reverse_table['<NL>'])
                i += 4
            elif control_code == '<SP>':
                bytes_data.append(reverse_table['<SP>'])
                i += 4
            elif control_code == '<END>':
                bytes_data.append(reverse_table['<END>'])
                i += 5
                break
            elif control_code in reverse_table:
                bytes_data.append(reverse_table[control_code])
                i = end_idx + 1
            else:
                print(f"Warning: Unknown control code '{control_code}' at position {i}, skipping")
                i = end_idx + 1
        else:
            char = text[i]
            if char in reverse_table:
                bytes_data.append(reverse_table[char])
            else:
                print(f"Warning: Character '{char}' (U+{ord(char):04X}) not found in reverse table, skipping")
            i += 1

    if not bytes_data or bytes_data[-1] != finishing_pointer:
        bytes_data.append(finishing_pointer)

    return bytes_data


def main():
    config = CONFIG_INSERT

    # Paths
    rom_path = str(Path(config['rom_file_path']).resolve())

    text_file = config['output_file']
    # Escribimos de vuelta en la misma ROM para que el pipeline sea
    # encadenado (fuente + ASM + texto traducido, todo en output.gb).
    output_rom_path = rom_path

    # Load translation tables
    table, reverse_table = load_table(config['table_file'])
    if not reverse_table:
        print("Failed to load translation table")
        return

    # Parse the text file
    pointer_texts = parse_text_file(text_file)
    if not pointer_texts:
        print("No text found to insert")
        return

    print(f"Parsed {len(pointer_texts)} text entries from '{text_file}'")

    skip_offsets = set(config.get('skip_pointer_offsets', []))

    try:
        with open(rom_path, 'rb') as f:
            rom_data = bytearray(f.read())

        skipped = 0
        inserted = 0
        failed = 0

        for pointer_offset, text in pointer_texts.items():
            if pointer_offset in skip_offsets:
                skipped += 1
                continue

            if pointer_offset + 2 <= len(rom_data):
                # Leer el puntero desde la tabla EXPANDIDA (banco $11),
                # manteniendo la misma posicion relativa que la original.
                pointer_offset_expanded = (
                    EXPANDED_TABLE_OFFSET
                    + (pointer_offset - ORIGINAL_TABLE_OFFSET)
                )
                pointer_value = struct.unpack(
                    '<H',
                    rom_data[pointer_offset_expanded:pointer_offset_expanded + 2]
                )[0]

                # Direccion fisica del texto dentro de la expansion:
                # el banco $11 esta mapeado en CPU $4000, y su base
                # fisica es 0x44000.
                actual_address = EXPANDED_TABLE_OFFSET + (pointer_value - 0x4000)

                byte_data = text_to_bytes(text, reverse_table, config['finishing_pointer'])

                original = bytearray()
                p = actual_address
                while p < len(rom_data):
                    original.append(rom_data[p])
                    if rom_data[p] == config['finishing_pointer']:
                        break
                    p += 1

                if bytes(original) == bytes(byte_data):
                    skipped += 1
                    continue

                end_address = actual_address + len(byte_data)
                if end_address <= len(rom_data):
                    rom_data[actual_address:end_address] = byte_data
                    inserted += 1
                    print(f"WROTE   {len(byte_data):3d} bytes at ${actual_address:04X} (pointer @ ${pointer_offset:04X})")
                else:
                    failed += 1
                    print(f"Error: Text at ${pointer_offset:04X} too long for space at ${actual_address:04X}")
            else:
                print(f"Error: Pointer offset ${pointer_offset:04X} out of ROM bounds")

        print()
        print(f"Resumen: {inserted} insertados, {skipped} sin cambios (skip), {failed} fallidos")

        with open(output_rom_path, 'wb') as f:
            f.write(rom_data)

        print(f"Text insertion complete. Modified ROM written to '{output_rom_path}'")

    except (FileNotFoundError, PermissionError) as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    main()
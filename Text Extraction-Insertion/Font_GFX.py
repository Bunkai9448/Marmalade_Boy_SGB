# =========================
# Configuration
# =========================

INPUT_FILE = "Marmalade Boy (Japan).gb"
EXTRACTED_FILE = "Font.bin"
OUTPUT_FILE = "Marmalade Boy (SPA_Font).gb"

START_ADDRESS = 0x33900
NUMBER_OF_BYTES = 0x300


# =========================
# Functions
# =========================

def extract_bytes(input_file, output_file, start_address, number_of_bytes):

    with open(input_file, "rb") as f:
        f.seek(start_address)
        data = f.read(number_of_bytes)

    if len(data) != number_of_bytes:
        raise ValueError(
            f"File does not contain {number_of_bytes:#x} bytes "
            f"starting at address {start_address:#x}."
        )

    with open(output_file, "wb") as f:
        f.write(data)

    print(f"Extracted {len(data):#x} bytes")
    print(f"Start address: {start_address:#x}")
    print(f"Output file: {output_file}")


def insert_bytes(input_file, insert_file, output_file, start_address):

    with open(input_file, "rb") as f:
        original_data = f.read()

    with open(insert_file, "rb") as f:
        insert_data = f.read()

    if start_address > len(original_data):
        raise ValueError(
            f"Start address {start_address:#x} is beyond the end "
            f"of the input file ({len(original_data):#x})."
        )

    end_address = start_address + len(insert_data)

    if end_address > len(original_data):
        raise ValueError(
            f"Not enough space in the input file.\n"
            f"Start address: {start_address:#x}\n"
            f"Bytes to insert: {len(insert_data):#x}\n"
            f"Input file size: {len(original_data):#x}"
        )

    modified_data = (
        original_data[:start_address]
        + insert_data
        + original_data[end_address:]
    )

    with open(output_file, "wb") as f:
        f.write(modified_data)

    print(f"Inserted {len(insert_data):#x} bytes")
    print(f"Start address: {start_address:#x}")
    print(f"End address: {end_address:#x}")
    print(f"Output file: {output_file}")


# =========================
# Main
# =========================

if __name__ == "__main__":

    # Extract bytes
#    extract_bytes( INPUT_FILE, EXTRACTED_FILE, START_ADDRESS, NUMBER_OF_BYTES)

    # Insert them back
    insert_bytes( INPUT_FILE, EXTRACTED_FILE, OUTPUT_FILE, START_ADDRESS)
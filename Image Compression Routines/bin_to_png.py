import sys
import os
from PIL import Image
import glob

def bin_to_png(input_file, output_file, width_tiles=16):
    # Game Boy color palette (4 shades of gray)
    palette = [
        (255, 255, 255),  # White
        (192, 192, 192),  # Light gray
        (96, 96, 96),     # Dark gray
        (0, 0, 0)         # Black
    ]

    # Read the binary file
    with open(input_file, 'rb') as f:
        data = f.read()

    # Each tile is 8x8 pixels, 2 bits per pixel, 16 bytes per tile (planar 2bpp)
    tile_size = 16
    tiles = [data[i:i + tile_size] for i in range(0, len(data), tile_size)]

    # Image dimensions (16 tiles × 8 pixels/tile = 128x128 pixels)
    tile_width = 8
    tile_height = 8
    img_width = width_tiles * tile_width
    img_height = (len(tiles) // width_tiles + (1 if len(tiles) % width_tiles else 0)) * tile_height

    # Create a new image
    image = Image.new('RGB', (img_width, img_height), color=palette[0])
    pixels = image.load()

    # Process each tile
    for tile_idx, tile_data in enumerate(tiles):
        if len(tile_data) != tile_size:
            continue  # Skip incomplete tiles

        # Calculate tile position in the image
        tile_x = (tile_idx % width_tiles) * tile_width
        tile_y = (tile_idx // width_tiles) * tile_height

        # Decode tile data (2bpp planar)
        for y in range(8):
            # Each row is 2 bytes (one for each bitplane)
            byte1 = tile_data[y * 2]  # Low bitplane
            byte2 = tile_data[y * 2 + 1]  # High bitplane

            for x in range(8):
                # Extract bits from each bitplane
                bit1 = (byte1 >> (7 - x)) & 1  # Low bit
                bit2 = (byte2 >> (7 - x)) & 1  # High bit
                color_idx = (bit2 << 1) | bit1  # Combine: 00, 01, 10, 11
                pixels[tile_x + x, tile_y + y] = palette[color_idx]

    # Save the image as PNG
    image.save(output_file, 'PNG')
    print(f"Image saved as {output_file}")

if __name__ == "__main__":
    # Create PNGs directory if it doesn't exist
    output_dir = "PNGs"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Find all .bin files in the current directory
    bin_files = glob.glob("*.bin")
    
    if not bin_files:
        print("No .bin files found in the current directory")
        sys.exit(1)

    # Process each .bin file
    for input_file in bin_files:
        # Generate output filename (replace .bin with .png)
        output_filename = os.path.splitext(input_file)[0] + ".png"
        # Place output file in PNGs directory
        output_file = os.path.join(output_dir, output_filename)
        bin_to_png(input_file, output_file)
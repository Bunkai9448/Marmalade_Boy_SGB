import sys
from PIL import Image

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
    if len(sys.argv) < 3:
        print("Usage: python bin_to_png.py <input.bin> <output.png>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    bin_to_png(input_file, output_file)

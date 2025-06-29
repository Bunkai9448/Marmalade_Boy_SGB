import sys
from PIL import Image
import numpy as np

def png_to_bin(input_file, output_file, width_tiles=16):
    # Game Boy color palette (4 shades of gray)
    palette = [
        (255, 255, 255),  # White (index 0)
        (192, 192, 192),  # Light gray (index 1)
        (96, 96, 96),     # Dark gray (index 2)
        (0, 0, 0)         # Black (index 3)
    ]

    # Load the PNG image
    image = Image.open(input_file).convert('RGB')
    pixels = np.array(image)

    # Image dimensions
    tile_width = 8
    tile_height = 8
    img_width, img_height = image.size

    # Calculate number of tiles
    tiles_x = img_width // tile_width
    tiles_y = img_height // tile_height
    if tiles_x < width_tiles:
        width_tiles = tiles_x  # Adjust width_tiles if image is narrower

    # Initialize binary output
    binary_data = bytearray()

    # Process each tile
    for tile_idx in range(tiles_y * width_tiles):
        tile_x = (tile_idx % width_tiles) * tile_width
        tile_y = (tile_idx // width_tiles) * tile_height

        # Skip tiles outside image bounds
        if tile_y >= img_height:
            continue

        # Process each tile (8x8 pixels)
        tile_data = bytearray(16)  # 16 bytes per tile (2bpp planar)
        for y in range(tile_height):
            for x in range(tile_width):
                # Get pixel color
                pixel_x = tile_x + x
                pixel_y = tile_y + y
                if pixel_x >= img_width or pixel_y >= img_height:
                    color = palette[0]  # Default to white for out-of-bounds
                else:
                    color = tuple(pixels[pixel_y, pixel_x])

                # Find closest palette color
                color_idx = 0
                min_dist = float('inf')
                for idx, pal_color in enumerate(palette):
                    dist = sum((c - p) ** 2 for c, p in zip(color, pal_color))
                    if dist < min_dist:
                        min_dist = dist
                        color_idx = idx

                # Set bits in the two bitplanes
                bit1 = color_idx & 1  # Low bit
                bit2 = (color_idx >> 1) & 1  # High bit
                byte_idx = y * 2
                bit_pos = 7 - x
                tile_data[byte_idx] |= (bit1 << bit_pos)
                tile_data[byte_idx + 1] |= (bit2 << bit_pos)

        binary_data.extend(tile_data)

    # Write to binary file
    with open(output_file, 'wb') as f:
        f.write(binary_data)
    print(f"Binary file saved as {output_file}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python png_to_bin.py <input.png> <output.bin>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    png_to_bin(input_file, output_file)
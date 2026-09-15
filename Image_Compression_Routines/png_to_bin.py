import sys
import os
import glob
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


# ============================================================
# Tilemap-aware reinsertion
#
# png_to_bin() above assumes a raw tile sheet (16 tiles per row) with no
# reuse -- fine for a simple 1:1 tile dump, but not what an edited,
# tilemap-arranged screen (from bin_to_png.py's tilemap_to_png) actually
# needs: cells that are genuinely unchanged should keep their original
# tile index, and only edited/new cells should get new tile data appended.
# ============================================================

PALETTE = [
    (255, 255, 255),  # 0 - White
    (192, 192, 192),  # 1 - Light gray
    (96, 96, 96),      # 2 - Dark gray
    (0, 0, 0),          # 3 - Black
]

TILE_SIZE = 16   # bytes per 2bpp tile
TILE_PX = 8      # pixels per tile side


def _decode_tile(tile_bytes):
    """16 raw 2bpp bytes -> 8x8 list of palette indices (0-3)."""
    px = [[0] * TILE_PX for _ in range(TILE_PX)]
    for y in range(TILE_PX):
        lo = tile_bytes[y * 2]
        hi = tile_bytes[y * 2 + 1]
        for x in range(TILE_PX):
            bit = 7 - x
            px[y][x] = (((hi >> bit) & 1) << 1) | ((lo >> bit) & 1)
    return px


def _encode_tile(px):
    """8x8 list of palette indices (0-3) -> 16 raw 2bpp bytes."""
    out = bytearray(16)
    for y in range(TILE_PX):
        lo = hi = 0
        for x in range(TILE_PX):
            bit = 7 - x
            color = px[y][x]
            lo |= (color & 1) << bit
            hi |= ((color >> 1) & 1) << bit
        out[y * 2] = lo
        out[y * 2 + 1] = hi
    return bytes(out)


def _read_tile_data(tile_bin_paths):
    """tile_bin_paths: a single path, or a list of paths concatenated in
    order -- must match whatever was passed to tilemap_to_png for the
    original render."""
    if isinstance(tile_bin_paths, str):
        tile_bin_paths = [tile_bin_paths]
    data = b''
    for p in tile_bin_paths:
        with open(p, 'rb') as f:
            data += f.read()
    return data


def png_to_tilemap_and_bin(edited_png_path, original_tile_bin_paths,
                             map_width_tiles, map_height_tiles,
                             output_tile_bin_path, output_tilemap_bin_path,
                             original_tilemap_path=None, palette=None,
                             visible_width_tiles=None, visible_height_tiles=None):
    """
    Reverse of tilemap_to_png(): take an edited arranged PNG and produce an
    updated tile-graphics bin + tilemap bin. Cells whose 8x8 pixels exactly
    match an existing tile reuse that tile's index; cells that don't match
    anything get a new tile appended. Pass original_tilemap_path so that
    genuinely-unchanged cells keep their exact original index (rather than
    an arbitrary but visually-identical duplicate).

    visible_width_tiles / visible_height_tiles: REQUIRED if the PNG was
    rendered with cropping (tilemap_to_png's visible_width_tiles/
    visible_height_tiles). The edited PNG is then the smaller, cropped
    size, not the full map_width x map_height -- cells outside the visible
    area have no corresponding pixel data at all (they were never shown to
    edit), so they're copied byte-for-byte from original_tilemap_path
    instead of being compared against anything. original_tilemap_path is
    therefore effectively required whenever cropping is used -- there
    would be no way to know what those off-screen cells should be
    otherwise.

    Returns (num_original_tiles, num_new_tiles_added).
    """
    pal = palette or PALETTE

    tile_data = bytearray(_read_tile_data(original_tile_bin_paths))
    n_original_tiles = len(tile_data) // TILE_SIZE

    original_tilemap = None
    if original_tilemap_path:
        with open(original_tilemap_path, 'rb') as f:
            original_tilemap = f.read()

    cropped = visible_width_tiles is not None or visible_height_tiles is not None
    vis_w = visible_width_tiles or map_width_tiles
    vis_h = visible_height_tiles or map_height_tiles

    if cropped and original_tilemap is None:
        raise ValueError(
            "visible_width_tiles/visible_height_tiles given but no "
            "original_tilemap_path -- off-screen cells (outside the "
            "visible/edited area) have no pixel data to read them from, so "
            "the original tilemap is required to preserve them correctly"
        )

    existing_by_pixels = {}
    for i in range(n_original_tiles):
        raw = bytes(tile_data[i * TILE_SIZE:(i + 1) * TILE_SIZE])
        px = tuple(tuple(row) for row in _decode_tile(raw))
        existing_by_pixels.setdefault(px, i)

    img = Image.open(edited_png_path).convert('RGB')
    img_w, img_h = img.size
    expected_w = vis_w * TILE_PX
    expected_h = vis_h * TILE_PX
    if (img_w, img_h) != (expected_w, expected_h):
        raise ValueError(
            f"{edited_png_path} is {img_w}x{img_h}, expected {expected_w}x{expected_h} "
            f"for the visible {vis_w}x{vis_h} area"
            + (f" (full map in VRAM is {map_width_tiles}x{map_height_tiles}, "
               f"cropped to what's actually shown)" if cropped else "")
        )
    src_px = img.load()

    def nearest_palette_index(rgb):
        best_idx, best_dist = 0, float('inf')
        for idx, pcolor in enumerate(pal):
            dist = sum((a - b) ** 2 for a, b in zip(rgb, pcolor))
            if dist < best_dist:
                best_dist, best_idx = dist, idx
        return best_idx

    new_tiles_by_pixels = {}
    tilemap = bytearray(map_width_tiles * map_height_tiles)
    num_new = 0
    num_kept_original = 0
    num_offscreen_preserved = 0

    for row in range(map_height_tiles):
        for col in range(map_width_tiles):
            cell = row * map_width_tiles + col

            # Off-screen cell (outside the visible/edited area): no pixel
            # data exists for it at all -- preserve exactly, byte for byte.
            if col >= vis_w or row >= vis_h:
                tilemap[cell] = original_tilemap[cell]
                num_offscreen_preserved += 1
                continue

            ox, oy = col * TILE_PX, row * TILE_PX
            cell_px = tuple(
                tuple(nearest_palette_index(src_px[ox + x, oy + y]) for x in range(TILE_PX))
                for y in range(TILE_PX)
            )

            if original_tilemap is not None:
                orig_idx = original_tilemap[cell]
                if orig_idx < n_original_tiles:
                    orig_px = tuple(tuple(r) for r in _decode_tile(
                        bytes(tile_data[orig_idx * TILE_SIZE:(orig_idx + 1) * TILE_SIZE])))
                    if orig_px == cell_px:
                        tilemap[cell] = orig_idx
                        num_kept_original += 1
                        continue

            if cell_px in existing_by_pixels:
                tilemap[cell] = existing_by_pixels[cell_px]
            elif cell_px in new_tiles_by_pixels:
                tilemap[cell] = new_tiles_by_pixels[cell_px]
            else:
                new_idx = n_original_tiles + num_new
                if new_idx > 0xFF:
                    raise ValueError(
                        f"ran out of tile-index space (>255 tiles needed) at "
                        f"cell ({col},{row}) -- this tilemap format uses a "
                        f"single byte per cell, so 256 unique tiles is the max"
                    )
                new_tiles_by_pixels[cell_px] = new_idx
                tile_data.extend(_encode_tile([list(r) for r in cell_px]))
                tilemap[cell] = new_idx
                num_new += 1

    with open(output_tile_bin_path, 'wb') as f:
        f.write(tile_data)
    with open(output_tilemap_bin_path, 'wb') as f:
        f.write(tilemap)

    print(f"Tile bin: {n_original_tiles} original tiles + {num_new} new tiles "
          f"= {n_original_tiles + num_new} total -> {output_tile_bin_path}")
    offscreen_note = (f", {num_offscreen_preserved} off-screen cells preserved"
                       if cropped else "")
    print(f"Tilemap: {map_width_tiles}x{map_height_tiles}, {num_kept_original} "
          f"cells kept their exact original index{offscreen_note} "
          f"-> {output_tilemap_bin_path}")
    return n_original_tiles, num_new


# ============================================================
# Screen definitions
#
# Must match the SCREENS dict in bin_to_png.py exactly -- these are the
# same screens, just going in reverse. Copy any new entry over from there
# when you add one.
# ============================================================

SCREENS = {

    "title_screen": {
        "tiles": ["0x2401A.bin", "0x246C0.bin"],
        "tilemap": "0x24A61.bin",
        "width": 32,
        "height": 18,
        "visible_width": 20,
        "visible_height": 18,
        "png_name": "2401A_titlescreen",
        "tilemap_name": "24A61_titlescreen_tilemap",
    },

    # Add more screens here (matching bin_to_png.py's SCREENS):
    #
    # "copyright": {
    #     "tiles": "0x257BB.bin",
    #     "tilemap": "0x25XXX.bin",
    #     "width": 32,
    #     "height": 18,
    #     "visible_width": 20,   # optional -- omit if not cropped
    #     "visible_height": 18,  # optional -- omit if not cropped
    # },

}


def reverse_screen(name, png_dir="PNGs", output_dir="BIN"):
    if name not in SCREENS:
        print(f"Unknown screen: {name}")
        print(f"Available screens: {', '.join(SCREENS)}")
        sys.exit(1)

    screen = SCREENS[name]
    png_filename = screen.get("png_name", name)
    edited_png_path = os.path.join(png_dir, f"{png_filename}.png")
    if not os.path.exists(edited_png_path):
        print(f"Edited PNG not found: {edited_png_path}")
        print(f"(render it first with bin_to_png.py, edit it, then run this)")
        sys.exit(1)

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    tiles_filename = screen.get("png_name", f"{name}_tiles")
    tilemap_filename = screen.get("tilemap_name", f"{name}_tilemap")
    output_tile_bin = os.path.join(output_dir, f"{tiles_filename}.bin")
    output_tilemap_bin = os.path.join(output_dir, f"{tilemap_filename}.bin")

    png_to_tilemap_and_bin(
        edited_png_path, screen["tiles"],
        screen["width"], screen["height"],
        output_tile_bin, output_tilemap_bin,
        original_tilemap_path=screen["tilemap"],
        visible_width_tiles=screen.get("visible_width"),
        visible_height_tiles=screen.get("visible_height"),
    )


def print_help():
    print("Usage:")
    print()
    print("  python png_to_bin.py all")
    print("      Reverse every screen in SCREENS (reads PNGs/<name>.png,")
    print("      writes BIN/<name>_tiles.bin + BIN/<name>_tilemap.bin).")
    print()
    print("  python png_to_bin.py SCREEN_NAME")
    print("      Reverse only the specified screen.")
    print()
    print("  python png_to_bin.py [--help]")
    print("      Show this help message.")
    print()
    print("Available screens:")
    for name in SCREENS:
        print(f"  {name}")


if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] in ("--help", "-h"):
        print_help()
        sys.exit(0)

    arg = sys.argv[1]
    if arg == "all":
        for name in SCREENS:
            reverse_screen(name)
    else:
        reverse_screen(arg)
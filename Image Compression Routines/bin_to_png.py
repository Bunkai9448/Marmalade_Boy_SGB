import sys
import os
import glob
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

    # Skip empty/incomplete BINs. These may be non-graphics data such as
    # tilemaps or other decompressed resources.
    if len(data) < 16:
        print(f"Skipping {input_file}: only {len(data)} bytes (not a complete 2bpp tile)")
        return

    # Ignore a trailing partial tile rather than creating an invalid image.
    complete_size = (len(data) // 16) * 16
    if complete_size != len(data):
        print(f"Warning: {input_file} has {len(data) % 16} trailing bytes; ignoring them")
        data = data[:complete_size]

    if not data:
        print(f"Skipping {input_file}: no complete 2bpp tiles")
        return

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


# ============================================================
# Tilemap-aware rendering / reinsertion
#
# bin_to_png() above lays tiles out in raw storage order (16 per row) --
# fine for eyeballing a tile sheet, but not what's actually on screen: the
# tilemap decides which tile index goes in which screen position, and the
# same tile can be reused in multiple places. These functions use the
# tilemap to render (and, on the way back, rebuild) the ACTUAL arranged
# image instead of a raw tile sheet.
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
    order. Some screens' tile indices span more than one compressed block
    (e.g. the title screen references indices up to 255, which needs two
    blocks concatenated to cover)."""
    if isinstance(tile_bin_paths, str):
        tile_bin_paths = [tile_bin_paths]
    data = b''
    for p in tile_bin_paths:
        with open(p, 'rb') as f:
            data += f.read()
    return data


def tilemap_to_png(tile_bin_paths, tilemap_bin_path, map_width_tiles,
                    map_height_tiles, output_png_path, palette=None,
                    visible_width_tiles=None, visible_height_tiles=None):
    """
    Render the actual arranged image from tile-graphics bin(s) + a tilemap
    bin. tile_bin_paths may be a single path or a list of paths (see
    _read_tile_data). tilemap_bin_path is one byte per cell = tile index.

    map_width_tiles / map_height_tiles must match the tilemap's real
    dimensions in VRAM (e.g. 32x18) -- needed to parse the tilemap bytes
    correctly, regardless of how much of it is actually shown on screen.

    visible_width_tiles / visible_height_tiles: optional. The Game Boy
    background map in VRAM is always the full map_width x map_height, but
    the hardware only displays a scrolled 20x18-tile window of it -- the
    rest just sits there unused. If given, the output PNG is cropped to
    this size (from the top-left) instead of showing the full map, so any
    unused/off-screen padding never has to be manually cropped or
    accidentally left in.
    """
    pal = palette or PALETTE

    tile_data = _read_tile_data(tile_bin_paths)
    with open(tilemap_bin_path, 'rb') as f:
        tilemap = f.read()

    n_tiles = len(tile_data) // TILE_SIZE
    tiles = [_decode_tile(tile_data[i * TILE_SIZE:(i + 1) * TILE_SIZE])
             for i in range(n_tiles)]

    expected_cells = map_width_tiles * map_height_tiles
    if len(tilemap) < expected_cells:
        raise ValueError(
            f"tilemap has {len(tilemap)} bytes, need {expected_cells} "
            f"for a {map_width_tiles}x{map_height_tiles} map"
        )

    img = Image.new('RGB', (map_width_tiles * TILE_PX, map_height_tiles * TILE_PX))
    out_px = img.load()

    missing_tiles = set()
    for cell in range(expected_cells):
        tile_idx = tilemap[cell]
        col = cell % map_width_tiles
        row = cell // map_width_tiles
        if tile_idx >= n_tiles:
            missing_tiles.add(tile_idx)
            continue
        tile_px = tiles[tile_idx]
        ox, oy = col * TILE_PX, row * TILE_PX
        for y in range(TILE_PX):
            for x in range(TILE_PX):
                out_px[ox + x, oy + y] = pal[tile_px[y][x]]

    if missing_tiles:
        print(f"WARNING: tilemap references {len(missing_tiles)} tile "
              f"index(es) not present in the given tile data (e.g. "
              f"{sorted(missing_tiles)[:10]}) -- likely need an additional "
              f"tile bin concatenated; pass tiles as a list, e.g. "
              f"[\"0x2401A.bin\", \"0x246C0.bin\"]")

    if visible_width_tiles is not None or visible_height_tiles is not None:
        crop_w = (visible_width_tiles or map_width_tiles) * TILE_PX
        crop_h = (visible_height_tiles or map_height_tiles) * TILE_PX
        img = img.crop((0, 0, crop_w, crop_h))

    img.save(output_png_path, 'PNG')
    crop_note = (f", cropped to visible {visible_width_tiles or map_width_tiles}x"
                 f"{visible_height_tiles or map_height_tiles}"
                 if (visible_width_tiles or visible_height_tiles) else "")
    print(f"Saved {output_png_path} ({map_width_tiles}x{map_height_tiles} tiles in "
          f"VRAM, {n_tiles} unique tiles available, {len(missing_tiles)} missing"
          f"{crop_note})")
    return img


def png_to_tilemap_and_bin(edited_png_path, original_tile_bin_paths,
                             map_width_tiles, map_height_tiles,
                             output_tile_bin_path, output_tilemap_bin_path,
                             original_tilemap_path=None, palette=None):
    """
    Reverse of tilemap_to_png(): take an edited arranged PNG and produce an
    updated tile-graphics bin + tilemap bin. Cells whose 8x8 pixels exactly
    match an existing tile reuse that tile's index; cells that don't match
    anything get a new tile appended. Pass original_tilemap_path so that
    genuinely-unchanged cells keep their exact original index (rather than
    an arbitrary but visually-identical duplicate) -- keeps diffs against
    the original minimal.

    Returns (num_original_tiles, num_new_tiles_added).
    """
    pal = palette or PALETTE

    tile_data = bytearray(_read_tile_data(original_tile_bin_paths))
    n_original_tiles = len(tile_data) // TILE_SIZE

    original_tilemap = None
    if original_tilemap_path:
        with open(original_tilemap_path, 'rb') as f:
            original_tilemap = f.read()

    existing_by_pixels = {}
    for i in range(n_original_tiles):
        raw = bytes(tile_data[i * TILE_SIZE:(i + 1) * TILE_SIZE])
        px = tuple(tuple(row) for row in _decode_tile(raw))
        existing_by_pixels.setdefault(px, i)

    img = Image.open(edited_png_path).convert('RGB')
    img_w, img_h = img.size
    expected_w = map_width_tiles * TILE_PX
    expected_h = map_height_tiles * TILE_PX
    if (img_w, img_h) != (expected_w, expected_h):
        raise ValueError(
            f"{edited_png_path} is {img_w}x{img_h}, expected {expected_w}x{expected_h} "
            f"for a {map_width_tiles}x{map_height_tiles} tile map"
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

    for row in range(map_height_tiles):
        for col in range(map_width_tiles):
            ox, oy = col * TILE_PX, row * TILE_PX
            cell_px = tuple(
                tuple(nearest_palette_index(src_px[ox + x, oy + y]) for x in range(TILE_PX))
                for y in range(TILE_PX)
            )
            cell = row * map_width_tiles + col

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
    print(f"Tilemap: {map_width_tiles}x{map_height_tiles}, {num_kept_original} cells "
          f"kept their exact original index -> {output_tilemap_bin_path}")
    return n_original_tiles, num_new


def deduplicate_tiles(tile_bin_paths, tilemap_bin_path,
                       output_tile_bin_path, output_tilemap_bin_path):
    """
    Remove tiles that are exact pixel-duplicates of an earlier tile, and
    remap the tilemap to point at the surviving copy. Frees up index space
    for edits -- a tilemap byte can only address 256 distinct tiles, and a
    real map may already be using most or all of them with duplicates
    baked in (the title screen does, at 256/256 with 63 duplicates).

    Returns (n_before, n_after, n_removed).
    """
    tile_data = _read_tile_data(tile_bin_paths)
    with open(tilemap_bin_path, 'rb') as f:
        tilemap = bytearray(f.read())

    n_before = len(tile_data) // TILE_SIZE

    kept_tiles = bytearray()
    old_to_new = {}
    seen = {}

    for i in range(n_before):
        raw = tile_data[i * TILE_SIZE:(i + 1) * TILE_SIZE]
        px = tuple(tuple(row) for row in _decode_tile(raw))
        if px in seen:
            old_to_new[i] = seen[px]
        else:
            new_idx = len(kept_tiles) // TILE_SIZE
            seen[px] = new_idx
            old_to_new[i] = new_idx
            kept_tiles.extend(raw)

    for cell in range(len(tilemap)):
        old_idx = tilemap[cell]
        if old_idx in old_to_new:
            tilemap[cell] = old_to_new[old_idx]

    n_after = len(kept_tiles) // TILE_SIZE

    with open(output_tile_bin_path, 'wb') as f:
        f.write(kept_tiles)
    with open(output_tilemap_bin_path, 'wb') as f:
        f.write(tilemap)

    print(f"Deduplicated: {n_before} -> {n_after} tiles "
          f"({n_before - n_after} freed) -> {output_tile_bin_path}")
    print(f"Tilemap remapped -> {output_tilemap_bin_path}")
    return n_before, n_after, n_before - n_after


# ============================================================
# Screen definitions
#
# Each entry maps a human-readable screen name to the decompressed .bin
# files (as produced by Decompressor.py, named 0x<offset>.bin) that make
# up its tile graphics and tilemap, plus the tilemap's dimensions in tiles.
#
# "tiles" may be a single filename or a list of filenames concatenated in
# order -- some screens' tile indices span more than one compressed block.
# ============================================================

SCREENS = {

    "title_screen": {
        "tiles": ["0x2401A.bin", "0x246C0.bin"],
        "tilemap": "0x24A61.bin",
        "width": 32,
        "height": 18,
        # Verified: every real tile (logo, menu text) is in columns 0-19;
        # columns 20-31 are entirely tile 0xFF, which decodes to 16 zero
        # bytes -- a genuinely blank tile, matching the Game Boy's 20-tile-
        # wide visible window into the full 32-wide VRAM map. Cropping to
        # it avoids ever needing to remember to trim that padding by hand.
        "visible_width": 20,
        "visible_height": 18,
        # Output naming -- ties each output file back to its ROM offset so
        # it's obvious which file goes where on reinsertion. png_name is
        # used for both the rendered PNG and (in png_to_bin.py) the tiles
        # bin it reverses into; tilemap_name is used for the tilemap bin.
        "png_name": "2401A_titlescreen",
        "tilemap_name": "24A61_titlescreen_tilemap",
    },

    # Add more screens here:
    #
    # "copyright": {
    #     "tiles": "0x257BB.bin",
    #     "tilemap": "0x25XXX.bin",
    #     "width": 32,
    #     "height": 18,
    #     "visible_width": 20,   # optional -- omit to keep the full map
    #     "visible_height": 18,  # optional -- omit to keep the full map
    # },

}


def render_screen(name, output_dir="PNGs"):
    if name not in SCREENS:
        print(f"Unknown screen: {name}")
        print(f"Available screens: {', '.join(SCREENS)}")
        sys.exit(1)

    screen = SCREENS[name]
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    output_filename = screen.get("png_name", name)
    output_path = os.path.join(output_dir, f"{output_filename}.png")
    tilemap_to_png(screen["tiles"], screen["tilemap"],
                   screen["width"], screen["height"], output_path,
                   visible_width_tiles=screen.get("visible_width"),
                   visible_height_tiles=screen.get("visible_height"))


def print_help():
    print("Usage:")
    print()
    print("  python bin_to_png.py all")
    print("      Render every screen in SCREENS.")
    print()
    print("  python bin_to_png.py SCREEN_NAME")
    print("      Render only the specified screen.")
    print()
    print("  python bin_to_png.py [--help]")
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
            render_screen(name)
    else:
        render_screen(arg)
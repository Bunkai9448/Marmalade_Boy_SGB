# Image Compression Tools - Readme

## English
Tools for compress and decompress images for the sgb game.  
- Marmalade Boy (Japan).sgb
- CRC 32: 0F3FF7DA

You will need a copy of your rom "Marmalade Boy.gb" and python 3  

1-Place the rom in the folder with the files  
2-Run the file Decompressor.py (Extract the compressed graphics from the listed offsets)  
3-Run the file Compressor.py (Compress the graphics using the game algorithm)  
Notes: 
You can add more graphics in the Decompressor, just add the corresponding offset.    
To compress add its (name).bin to the Compressor.

## Español
Herramientas para comprimir y descomprimir imágenes del juego para sgb.   
- Marmalade Boy (Japan).sgb
- CRC 32: 0F3FF7DA

Necesitarás una copia de tu rom "Marmalade Boy.gb" y python 3  

1-Coloca el rom en la carpeta con los archivos  
2-Ejecuta el archivo Decompressor.py (Extrae los graficos comprimidos desde los offsets enlistados)  
3-Ejecuta el archivo Compressor.py (Comprime los graficos usando el algoritmo del juego)  
Notas: 
Puedes agregar mas graficos en el Decompressor, solo agrega el offset correspondiente.  
Para comprimir agrega su (nombre).bin al Compressor.

## Pointer tables for Compressed images:

| ROM bank | Pointer table | Examples of graphics it points to                                                         |
| -------- | ------------: | ----------------------------------------------------------------------------------------- |
| Bank 6   | **`0x18000`** | `0x19DD9`, `0x1A4E3`, `0x1AD85`, `0x1AFCE`, `0x1B4B8`...                                  |
| Bank 7   | **`0x1C000`** | `0x1C9FA`, `0x1D855`, `0x1E7CC`, `0x1EFD9`, `0x1F66E`...                                  |
| Bank 8   | **`0x20000`** | `0x20DA1`, `0x21624`, `0x218E5`, `0x21AFE`, `0x22188`...                                  |
| Bank 9   | **`0x24000`** | `0x2401A`, `0x246C0`, `0x24BA8`, `0x25280`, `0x257BB`, `0x25DE8`, `0x265A1`...            |
| Bank A   | **`0x28000`** | `0x28B8E`, `0x2979B`...                                                                   |
| Bank B   | **`0x2C000`** | `0x2DF04`, `0x2E9C6`, `0x2EF8E`, `0x2F1E8`, `0x2F64B`, `0x2F855`...                       |
| Bank C   | **`0x30000`** | `0x302C6`, `0x3059C`, `0x307F1`, `0x30967`, `0x31374`, `0x317C1`...                       |
| Bank D   | **`0x34000`** | `0x35065`, `0x356E2`, `0x35BBE`, `0x361AF`, `0x3639D`, `0x36A1B`, `0x36EAF`, `0x3761F`... |


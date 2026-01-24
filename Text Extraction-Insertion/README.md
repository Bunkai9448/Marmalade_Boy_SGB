# Game Script Extraction/Insertion

This is just a proof of concept, deliberatedly lacking, so it can be preserved in case something happens to my files.

I have the full script dumped and translated, but I will keep that private with other files and info to avoid leaks.


## Data Info

Text Proof Of Concept:
```
//BLOCK #001 NAME:        First Dialogue of the game

//POINTER #0 @ $C000 - STRING #0 @ $C004

#W16($C000)
あなたのおたん生日[NL]
を　おしえて！？<$F0>
```

Font offset and encode:
```
15x12 tiles
1bpp planar
$33900
```

## How to use

*Notice: You can use these if you want to test or learn about it to help with the project.*

- [Cartographer](https://www.romhacking.net/utilities/647/) commands for a script dump
```
#GAME NAME:   	Marmalade Boy (Japan).sgb

#BLOCK NAME:   	Marmalade_Boy (001)
#METHOD: POINTER_RELATIVE
#POINTER ENDIAN: LITTLE
#POINTER TABLE START: $C000 // $13EBB
#POINTER TABLE STOP: $C004
#POINTER SIZE: $02
#POINTER SPACE: $00
#ATLAS PTRS: Yes
#BASE POINTER:	$8000
#TABLE: FontTable.tbl
#COMMENTS: No
#END BLOCK
```
Open the terminal and run : `cartographer "Marmalade Boy (Japan).sgb" Marmalade_commands.txt Marmalade_script -s`

- [Atlas](https://www.romhacking.net/utilities/224/) commands for a script insertion
```
// Atlas required info for reinsertion

#VAR(Table, TABLE)
#ADDTBL("FontTable.tbl", Table)
#ACTIVETBL(Table)

#VAR(PtrMarmalade, CUSTOMPOINTER)
#CREATEPTR(PtrMarmalade, "LINEAR", $8000, 16)
#VAR(PtrTblC000, POINTERTABLE)
#PTRTBL(PtrTblC000, $C000, 2, PtrMarmalade)
#AUTOWRITE(PtrTblC000, "<END>")
#JMP($C004)

// Append the dumped script below
```
Open the terminal and run : `Atlas "Marmalade Boy (Japan).sgb" Marmalade_script.txt`


- *Since Atlas and Cartographer are Windows only, I also used the (full) data to make a few python scripts 
(with AI help), so I can make the insertion/extraction in my unix systems too. But those scripts are private 
for the time being.*

## Extra:
To find the Keywords for the SFC game, better debugging, and more knowledge about the game. 
Here are some in-game passwords:

End of 2nd chapter Ginta:  
`て3け　ミワなに　・・そ　・イツイ`  
End of 2nd chapter Yuu:  
`つ3こ　ミワなに　・・そ　・イコイ`  

End of 3rd chapter spades remove success:  
`すに６　ワワカコ　ツちち　ちそツ６`  
End of 3rd chapter spades remove failure:  
`しせ６　ワワカコ　ワつて　てツ・へ`  

Story's End + Psychology results:  
`ふキき　ミワなに　なワキ　なツ38`  
Same ending, but only psycology results:  
`はとき　ミワなに　ミとキ　なつ38`  

Only Psychology results:  
`2せろ　ワワカコ　てつと　つつ・へ`  

Staff credits (hidden pass) from https://kakusi.jp/?p=52797:  
`キミワ　カシコイ　・・・　・・・・`





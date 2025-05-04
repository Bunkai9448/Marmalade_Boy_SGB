:: Delete previous test copies to avoid confusion
IF EXIST output.gb ( DEL output.gb )
:: Create a new test copy to work with
COPY "Marmalade Boy (Japan).gb" "output.gb"

:: Compile and Inject the changes
armips_at_gameboy test.asm > error.txt

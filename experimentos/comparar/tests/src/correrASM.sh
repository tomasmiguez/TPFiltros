> ASM.out
for file in compImg/*
do
	build/tp2 ImagenFantasma -i asm -t 100 $file 0 0 >> ASM.out
	build/tp2 ColorBordes -i asm -t 100 $file >> ASM.out
	build/tp2 ReforzarBrillo -i asm -t 100 $file 150 140 50 50 >> ASM.out
done
rm *.bmp
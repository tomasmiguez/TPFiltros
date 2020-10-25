> C.out
for file in compImg/*
do
	#build/tp2 ImagenFantasma -i c -t 200 $file 0 0 >> C.out
	#build/tp2 ColorBordes -i c -t 200 $file >> C.out
	build/tp2 ReforzarBrillo -i c -t 200 $file 150 140 50 50 >> C.out
done
rm *.bmp
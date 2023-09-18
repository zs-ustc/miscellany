#!/bin/bash
filename=data/POSCAR
if [ -f $filename ];then
	mkdir band
	mkdir band/3.pbe
	cp data/POSCAR band/POSCAR
	cd band/3.pbe
	ln -s ../POSCAR
	echo -e "103\n"|vaspkit | grep POTCAR File No. && mv POTCAR ../ && ln -s ../POTCAR
	cp ../../data/INCAR* .
	cp ../../vasp.sub pbe.sub
	cp INCAR.scf INCAR
	sbatch *.sub
	cd ../../..
fi


#dir=x
#for i in $(seq 1 22)
#do
#if [ -f data/POSCAR_${dir}${i} ];then
#	echo ${dir}${i}
#	mkdir band/${dir}${i}
#	mkdir band/${dir}${i}/3.pbe
#	cp data/POSCAR_${dir}${i} band/${dir}${i}/POSCAR
#	ln -s ../POTCAR band/${dir}${i}/POTCAR
#	cd band/${dir}${i}/3.pbe
#	ln -s ../POSCAR
#	ln -s ../POTCAR
#	cp ../../INCAR* .
#	cp ../../vasp.sub ${dir}${i}pbe.sub
#	cp INCAR.scf INCAR
#	sbatch *.sub
#	cd ../../..
#fi
#done

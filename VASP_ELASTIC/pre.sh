#!/bin/bash
# Shuai Zhao @ Jun 05, 2022

root_dir=`pwd`
mkdir 2.elastic
cd 2.elastic/
python ../deform.py
for i in $(seq 1 6)
do
	for j in $(seq 1 2)
	do
		mkdir vasp${i}${j}
		cd vasp${i}${j}
  		ln -s ${root_dir}/2.elastic/POSCAR/POSCAR${i}${j} POSCAR
  		ln -s ${root_dir}/1.relax/WAVECAR .
		ln -s ${root_dir}/1.relax/POTCAR POTCAR
		ln -s ${root_dir}/INCAR.isif2 INCAR
		cp ${root_dir}/vasp.sub ./vasp${i}${j}.sub
		sbatch *.sub
		cd ..
	done
done

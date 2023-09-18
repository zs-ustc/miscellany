#!/bin/bash

# Prepare necessiary files in data/ directory: POSCAR, INCAR.scf, vasp.sub
NCORE=16
# filename is the filename of POSCAR stored in data
filename=POSCAR
workspace=band
batch_type=sbatch
# batch_type=sh/qsub
pwd_init=`pwd`


if [ -f data/${filename} ];then
    mkdir ${workspace}
    mkdir ${workspace}/1.pbe_scf
    cp ${pwd_init}/data/POSCAR ${pwd_init}/${workspace}/POSCAR
    cd ${pwd_init}/${workspace}/1.pbe_scf
    ln -s ../POSCAR
    echo -e "103\n"|vaspkit | grep "POTCAR File No." && mv POTCAR ../ && ln -s ../POTCAR
    cp ${pwd_init}/data/INCAR.scf .
    cp ${pwd_init}/data/vasp.sub pbe_scf.sub
    cp INCAR.scf INCAR && sed -i "s/^.*NCORE.*$/NCORE = ${NCORE}/" INCAR
    if [ ${batch_type}=sh ];then
        nohup sh *.sub > sh_${workspace}_pbe_scf.out 2>&1 &
    else
        ${fp_cmd} *.sub
    fi
    cd ${pwd_init}
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

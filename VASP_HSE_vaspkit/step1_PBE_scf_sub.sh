#!/bin/bash

# Prepare necessiary files in data/ directory: POSCAR_filename, INCAR.scf, vasp.sub

# Parameters setting
    NCORE=16
    # filename is the filename of POSCAR stored in data
    filename=POSCAR
    workspace=band
    # Batch type
    batch_type=sbatch
     # batch_type=sh/qsub
echo "
Step 1: Perform scf calculation"


# Run
pwd_init=`pwd`
if [ -f data/${filename} ];then
    # Make directory
    mkdir ${workspace} && mkdir ${workspace}/1.pbe_scf

    # POSCAR and POTCAR for all calculations
    cp ${pwd_init}/data/${filename} ${pwd_init}/${workspace}/POSCAR
    echo -e "103\n"|vaspkit | grep "POTCAR File No."

    # POSCAR and POTCAR
    cd ${pwd_init}/${workspace}/1.pbe_scf
    ln -s ../POSCAR && ln -s ../POTCAR

    # INCAR
    cp ${pwd_init}/data/INCAR.scf INCAR && sed -i "s/^.*NCORE.*$/NCORE = ${NCORE}/" INCAR

    # Submitting script
    cp ${pwd_init}/data/vasp.sub ${filename}_pbe_scf.sub

    # Submit jobs
    if [ ${batch_type}=sh ];then
        nohup sh *.sub > sh_${workspace}_pbe_scf.out 2>&1 &
    else
        ${fp_cmd} *.sub
    fi

    # Get back to initial directory
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

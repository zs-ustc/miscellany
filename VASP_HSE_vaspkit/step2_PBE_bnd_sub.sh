#!/bin/bash

# Prepare necessiary files in data/ directory: POSCAR, INCAR.scf, vasp.sub

# Parameters setting
    NCORE=16
    # Filename is the filename of POSCAR stored in data
    filename=POSCAR
    workspace=band
    # Batch type
    batch_type=sbatch
    # batch_type=sh/qsub

pwd_init=`pwd`
if [ -f data/${filename} ];then
	# Make directory
    cd ${workspace} && mkdir 2.pbe_bnd && cd ${pwd_init}/${workspace}/2.pbe_bnd
	
	# Link POSCAR POTCAR WAVECAR CHGCAR
	ln -s ../POSCAR && ln -s ../POTCAR && ln -s ../1.*/WAVECAR && ln -s ../1.*/CHGCAR
    
	# KPOINTS: Get line-mode KPOINTS automatically:
	echo -e "302\n2\n" | vaspkit | grep ' ]'
	cp KPATH.in KPOINTS
	# Or you can use SeeKPATH website to obtain or check the high symmetry points
	 # cp ${pwd_init}/data/KPATH_${filename}.in KPATH.in
	 
	# INCAR
	cp ${pwd_init}/data/INCAR.bnd INCAR && sed -i "s/^.*NCORE.*$/NCORE = ${NCORE}/" INCAR
	
	# Submitting script
	cp ${pwd_init}/data/vasp.sub ${filename}_pbe_bnd.sub
	echo 'echo -e "211\n2\n" | vaspkit | grep BAND_GAP' >> ${filename}_pbe_bnd.sub
	
	# submit jobs
	if [ -f "../1.pbe_scf/finished" ];then
        if [ ${batch_type}=sh ];then
            nohup sh *.sub > ${workspace}_pbe_bnd.out 2>&1 &
			echo "Shell job's submitted, directory: ${pwd_init}/${workspace}/2.pbe_bnd"
        else
            ${fp_cmd} *.sub
        fi
	else
		echo "Very bad news!!! job of pbe_scf hasn't been finished successfully!!!"
		echo "Current directory is ${pwd_init}/${workspace}/2.pbe_bnd"
	fi
    cd ${pwd_init}
fi


#dir=x
#for i in $(seq 9 22)
#do
#	if [ -f data/POSCAR_${dir}${i} ];then
#		cd band/${dir}${i}/3.pbe
#		if [ -f "finished" ];then
#			echo ${dir}${i}
#			rm finished
#			cp -f INCAR.bnd INCAR
#			sbatch *.sub
#			cd ../../..
#		fi
#	fi
#done

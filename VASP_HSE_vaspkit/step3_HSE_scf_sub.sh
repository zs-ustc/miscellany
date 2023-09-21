#!/bin/bash

# Files required in data/ directory: POSCAR_filename, INCAR.scf, vasp.sub.hse_pbe

# Parameters setting
	I2D=1
    NCORE=15
    # Filename is the filename of POSCAR stored in data
	POSCAR_dir=CONTCAR_collect
    filename=POSCAR
    workspace=tension
    # Batch type
    batch_type=sh
    # batch_type=sh/qsub

echo "

Step 3/Step 1: BAND_GAP of PBE_PBE.

POSCAR name  :   data/${POSCAR_dir}/${filename}
Workspace    :   ${workspace}
Batch type   :   ${batch_type}"
[[ $I2D == 1 ]] && echo "Dimension    :   2D"
pwd_init=`pwd`
if [ -f data/${POSCAR_dir}/${filename} ];then
	# Make directory
	mkdir -p ${pwd_init}/${workspace}/3.hse_pbe && cd ${pwd_init}/${workspace}/3.hse_pbe
	
	# Link POSCAR POTCAR WAVECAR CHGCAR
	if [ -f ../POTCAR ]; then
		ln -s ../POSCAR && ln -s ../POTCAR 
	else
		cd ..
		cp ${pwd_init}/data/${POSCAR_dir}/${filename} ${pwd_init}/${workspace}/POSCAR
		echo -e "103\n"|vaspkit 2>&1| grep "POTCAR File No."
		cd 3.hse_pbe && ln -s ../POSCAR && ln -s ../POTCAR 
	fi
	
    
	# KPOINTS: Get line-mode KPOINTS automatically:
	if [ -f ../2.pbe_bnd/KPATH.in ];then
 		cp ../2.pbe_bnd/KPATH.in .
   	else
    		[[ ${I2D} == 1 ]] && echo -e "302\n2\n" | vaspkit | grep ' ]' || echo -e "303\n2\n" | vaspkit | grep ' ]'
    fi
	# Or use a specified KPATH only contains VBM and CBM
	 # cp ${pwd_init}/data/KPATH_${filename}.in KPATH.in
	echo -e "251\n2\n0.03\n0.04\n1\n" | vaspkit | grep "K-"
	# If possible, don't set ISYM=0 in INCAR.
	# Sometimes the generated KPOINTS considered the symmetry that might cause some error.
	# Otherwise, revise it with IBZKPT generated in 1.PBE_scf which is non-symmetry.
	
	
	# INCAR
	cp ${pwd_init}/data/INCAR.scf INCAR && sed -i "s/^.*NCORE.*$/NCORE = ${NCORE}/" INCAR
	
	# Submitting script
	cp ${pwd_init}/data/vasp.sub.hse_pbe ${filename}_hse_pbe.sub
	echo 'echo -e "252\n1\n" | vaspkit | grep BAND_GAP' >> ${filename}_hse_pbe.sub
	echo 'grep "Band Gap" BAND_GAP'>>${filename}_hse_pbe.sub
	
	# submit jobs
    if [ ${batch_type} == sh ];then
        nohup sh *.sub > ${workspace}_hse_pbe.out 2>&1 &
		echo "Shell job's submitted, directory: ${pwd_init}/${workspace}/3.hse_pbe"
    else
        ${batch_type} *.sub
    fi
	
	# Get back to initial directory
    cd ${pwd_init}
fi


#dir=x
#for i in $(seq 9 22)
#do
#	if [ -f data/POSCAR_${dir}${i} ];then
#		mkdir band/${dir}${i}/1.scf
#		cd band/${dir}${i}/1.scf
#		cp ../../INCAR.hsescf INCAR
#		cp ../../vasp.sub.hsescf ${dir}${i}scf.sub
#		ln -s ../POSCAR
#		ln -s ../POTCAR
#		cp ../../KPATH_HSE/KPATH_${dir}${i}.in KPATH.in
#		echo -e "251\n2\n0.03\n0.05\n1\n" | vaspkit # Get KPOINTS
#		sbatch *.sub
#		cd ../../..
#	fi
#done

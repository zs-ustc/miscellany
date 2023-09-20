#!/bin/bash

# Prepare necessiary files in data/ directory: POSCAR, INCAR.scf, vasp.sub.hse_pbe

# Parameters setting
    NCORE=16
    # Filename is the filename of POSCAR stored in data
    filename=POSCAR
    workspace=band
    # Batch type
    batch_type=sbatch
    # batch_type=sh/qsub
    
echo "

Step 4/Step 1: BAND_GAP of HSE06.

POSCAR name  :   ${filename}
Workspace    :   ${workspace}
Batch type   :   ${batch_type}"
[[ $I2D == 1 ]] && echo "Dimension    :   2D"

#run
pwd_init=`pwd`
if [ -f data/${filename} ];then
	# Make directory
	mkdir -p ${pwd_init}/${workspace}/4.hse_bnd && cd ${pwd_init}/${workspace}/4.hse_bnd
	if [ -f ../3.hse_pbe/finished ]; then
	# Link POSCAR POTCAR WAVECAR CHGCAR
	ln -s ../POSCAR && ln -s ../POTCAR && ln -s ../WAVECAR && ln -s ../CHGCAR
    
	# KPOINTS: Get line-mode KPOINTS automatically:
	cp ../3.hse_pbe/KPATH.in . && cp ../3.hse_pbe/KPOINTS .
	# Or use a specified KPATH only contains VBM and CBM
	 # cp ${pwd_init}/data/KPATH_${filename}.in KPATH.in
	# If possible, don't set ISYM=0 in INCAR.
	# Sometimes the generated KPOINTS considered the symmetry that might cause some error.
	# Otherwise, revise it with IBZKPT generated in 1.PBE_scf which is non-symmetry.
	
	
	# INCAR
	cp ${pwd_init}/data/INCAR.hse_bnd INCAR && sed -i "s/^.*NCORE.*$/NCORE = ${NCORE}/" INCAR
	
	# Submitting script
	cp ${pwd_init}/data/vasp.sub.hse_bnd ${filename}_hse_bnd.sub
	echo 'echo -e "252\n1\n" | vaspkit | grep BAND_GAP' >> ${filename}_hse_bnd.sub
	echo 'grep "Band Gap" BAND_GAP'>>${filename}_hse_bnd.sub
	
	# submit jobs
    if [ ${batch_type} == sh ];then
        nohup sh *.sub > ${workspace}_hse_bnd.out 2>&1 &
        echo "Shell job's submitted, directory: ${pwd_init}/${workspace}/4.hse_bnd"
    else
        ${fp_cmd} *.sub
    fi
	else
        echo "
 -----------------------------------------------------------------------------
|                                                                             |
|     EEEEEEE  RRRRRR   RRRRRR   OOOOOOO  RRRRRR      ###     ###     ###     |
|     E        R     R  R     R  O     O  R     R     ###     ###     ###     |
|     E        R     R  R     R  O     O  R     R     ###     ###     ###     |
|     EEEEE    RRRRRR   RRRRRR   O     O  RRRRRR       #       #       #      |
|     E        R   R    R   R    O     O  R   R                               |
|     E        R    R   R    R   O     O  R    R      ###     ###     ###     |
|     EEEEEEE  R     R  R     R  OOOOOOO  R     R     ###     ###     ###     |
|                                                                             |
|     No successfully finished hse_pbe job found, STOPPING                    |
|                                                                             |
|       ---->  I REFUSE TO CONTINUE WITH THIS SICK JOB ... BYE!!! <----       |
|                                                                             |
 -----------------------------------------------------------------------------
"
    fi
	# Get back to initial directory
    cd ${pwd_init}
fi


#dir=x
#for i in $(seq 9 22)
#do
#	if [ -f data/POSCAR_${dir}${i} ];then
#		if [ -f "band/${dir}${i}/1.scf/finished" ];then
#			mkdir band/${dir}${i}/2.hse
#			cd band/${dir}${i}/2.hse
#			cp ../../INCAR.hse INCAR
#			cp ../../vasp.sub.hse ${dir}${i}.sub
#			ln -s ../POSCAR
#			ln -s ../POTCAR
#			ln -s ../1.scf/WAVECAR
#			ln -s ../1.scf/CHGCAR
#			ln -s ../1.scf/KPATH.in
#			ln -s ../1.scf/KPOINTS
#			sbatch *.sub
#			cd ../../..
#		else
#			echo "error!!!${dir}${i}--------------------------------------------------------"
#		fi
#	fi
#done

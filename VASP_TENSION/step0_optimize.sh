#!/bin/bash

# Files used in data directory: POSCAR_filename, INCAR.isif3, vasp_relax.sub

# Parameters setting
	I2D=1
    NCORE=16
    # filename is the filename of POSCAR stored in data
    filename=POSCAR
    workspace=tension
    # Batch type
    batch_type=sbatch
     # batch_type=sh/qsub
echo "

Step 0: Structural optimization.
POSCAR name  :   ${filename}
Workspace    :   ${workspace}
Batch type   :   ${batch_type}" 
# Relaxation calculation
pwd_init=`pwd`
if [ -f data/${filename} ];then
    # Make directory
    mkdir -p ${pwd_init}/${workspace}/0.relax

    # POSCAR and POTCAR for all calculations
    cp ${pwd_init}/data/${filename} ${pwd_init}/${workspace}/POSCAR
	cd ${pwd_init}/${workspace}
	[[ ${I2D}=1 ]] && echo -e "923\n1\n"|vaspkit|grep POSCAR_REV && mv -f POSCAR_REV POSCAR
    echo -e "103\n"|vaspkit | grep "POTCAR File No."

    # POSCAR and POTCAR
    cd ${pwd_init}/${workspace}/0.relax
    ln -s ../POSCAR && ln -s ../POTCAR

    # INCAR
    cp ${pwd_init}/data/INCAR.isif3 INCAR && sed -i "s/^.*NCORE.*$/NCORE = ${NCORE}/" INCAR
    [[ ${I2D}=1 ]] && echo -e '100\n110\n000\n'> OPTCELL
	
    # Submitting script
    cp ${pwd_init}/data/vasp.sub ${filename}_relax.sub
	echo "mv ${pwd_init}/data/${filename} ${pwd_init}/data/${filename}.init">>${filename}_relax.sub
	echo "cp CONTCAR ${pwd_init}/data/${filename}_relaxed">>${filename}_relax.sub

    # Submit jobs
    if [ ${batch_type} == sh ];then
        nohup sh *.sub > ${workspace}_relax.out 2>&1 &
    else
        ${fp_cmd} *.sub
    fi

    # Get back to initial directory
    cd ${pwd_init}
fi
echo "Step 2: Done. VASP jobs are running in the background"
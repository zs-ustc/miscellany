#!/bin/bash

# Prepare necessiary files in data/ directory: POSCAR, INCAR.isif2, INCAR.scf, INCAR.isif3 , vasp.sub

# Parameters setting
	I2D=1
    NCORE=8
    # filename is the filename of POSCAR stored in data
    filename=POSCAR
    workspace=tension
    # Batch type
    batch_type=sh
     # batch_type=sh/qsub

echo "

Step 2: Uniaxial calculation.

POSCAR name  :   ${filename}
Workspace    :   ${workspace}
Batch type   :   ${batch_type}"
[[ $I2D == 1 ]] && echo "Dimension    :   2D"

# Relaxation calculation
pwd_init=`pwd`
for i in $(seq 1 3);do
[[ ${i} == 1 ]] && dir=x
[[ ${i} == 2 ]] && dir=y
[[ ${i} == 3 ]] && dir=z
if [ -f data/${filename} ];then
if [ $i -ne 3 ] || [ $I2D -ne 1 ]; then
    # Make directory
	cd ${pwd_init}/${workspace}/${dir}
	if [ ! -f finished ];then
		[[ ! -f Uniaxial.py ]] && ln -s ${pwd_init}/data/Uniaxial.py
		[[ ! -f read_stress_strain.py ]] && ln -s ${pwd_init}/data/read_stress_strain.py
		[[ ! -f read_stress_strain_current.py ]] && ln -s ${pwd_init}/data/read_stress_strain_current.py
		nohup python Uniaxial.py ${I2D} ${batch_type} > ../Uniaxial_${dir}.out 2>&1 &
		echo "nohup submitted python job: ${workspace}/Uniaxial_${dir}.out"
	else
		echo "Finished python job: ${workspace}/${dir}"
	fi

	
	
#    # POSCAR and POTCAR for all calculations
#    cp ${pwd_init}/data/POSCAR ${pwd_init}/${workspace}/POSCAR
#    echo -e "103\n"|vaspkit | grep "POTCAR File No."
#
#    # POSCAR and POTCAR
#    cd ${pwd_init}/${workspace}/0.relax
#    ln -s ../POSCAR && ln -s ../POTCAR
#
#    # INCAR
#    cp ${pwd_init}/data/INCAR.isif3 INCAR && sed -i "s/^.*NCORE.*$/NCORE = ${NCORE}/" INCAR
#    [[ ${I2D}=1 ]] && echo -e '110\n110\n000\n'> OPTCELL
#	
#    # Submitting script
#    cp ${pwd_init}/data/vasp.sub ${filename}_relax.sub
#
#    # Submit jobs
#    if [ ${batch_type}=sh ];then
#        nohup sh *.sub > ${workspace}_relax.out 2>&1 &
#    else
#        ${fp_cmd} *.sub
#    fi

    # Get back to initial directory
    cd ${pwd_init}
fi
fi
done
echo "Step 2: Done. Python jobs are running in the background"

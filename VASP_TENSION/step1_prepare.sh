#!/bin/bash

# Prepare necessiary files in data/ directory: POSCAR, INCAR.isif2, INCAR.scf, INCAR.isif3 , vasp.sub

# Parameters setting
	I2D=1
    NCORE=8
    # filename is the filename of POSCAR stored in data
    filename=POSCAR
    workspace=tension
    # Batch type
    batch_type=sbatch
     # batch_type=sh/qsub
echo "Step 1: prepare input files.
"
echo "Direction directories of ${filename} are:"

# Relaxation calculation
pwd_init=`pwd`
for i in $(seq 1 3);do
[[ ${i} == 1 ]] && dir=x
[[ ${i} == 2 ]] && dir=y
[[ ${i} == 3 ]] && dir=z
if [ -f data/${filename} ];then
if [ $i -ne 3 ] || [ $I2D -ne 1 ]; then
    # Make directory
	echo "${workspace}/${dir}"
    mkdir -p ${pwd_init}/${workspace}/${dir}/input
	cd ${pwd_init}/${workspace}/${dir}
	[[ -f ${pwd_init}/${workspace}/0.relax/finished ]] && cp -r  ${pwd_init}/${workspace}/0.relax vasp0000 || exit
    
	cd ${pwd_init}/${workspace}/${dir}/input
	ln -s ../../POTCAR
	[[ $I2D == 1 ]] && echo -e "010\n010\n000\n" >> OPTCELL1 && echo -e "100\n100\n000\n" >> OPTCELL2
    [[ $I2D -ne 1 ]] && echo -e "011\n011\n011\n" >> OPTCELL1 && echo -e "101\n101\n001\n" >> OPTCELL2 && echo -e "110\n110\n110\n" >> OPTCELL3 
	cp -s ${pwd_init}/data/INCAR.tension INCAR && sed -i "s/^.*NCORE.*$/NCORE = ${NCORE}/" INCAR
	cp -s ${pwd_init}/data/vasp.sub .
    
	# Get back to initial directory
	cd ${pwd_init}
fi
fi
done	

echo "Step 1: done."
	
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

    


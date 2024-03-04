#!/bin/bash
# Shuai Zhao @ Jun 05, 2022
# This file is to read the Stress of each OUTCAR and for the follow-up calculation of elastic constants
echo "Dir,sig+1,sig+2,sig+3,sig+4,sig+5,sig+6,sig-1,sig-2,sig-3,sig-4,sig-5,sig-6">./Elastic_stress.csv
for i in $(seq 1 6)
do
		sig1=$(grep "in kB" ./2.elastic/vasp${i}1/OUTCAR | tail -n 1 | awk '{print $3}')
		sig2=`grep "in kB" ./2.elastic/vasp${i}1/OUTCAR | tail -n 1 | awk '{print $4}'`
		sig3=`grep "in kB" ./2.elastic/vasp${i}1/OUTCAR | tail -n 1 | awk '{print $5}'`
		sig4=`grep "in kB" ./2.elastic/vasp${i}1/OUTCAR | tail -n 1 | awk '{print $6}'`
		sig5=`grep "in kB" ./2.elastic/vasp${i}1/OUTCAR | tail -n 1 | awk '{print $7}'`
		sig6=`grep "in kB" ./2.elastic/vasp${i}1/OUTCAR | tail -n 1 | awk '{print $8}'`
		sig7=$(grep "in kB" ./2.elastic/vasp${i}2/OUTCAR | tail -n 1 | awk '{print $3}')
		sig8=`grep "in kB" ./2.elastic/vasp${i}2/OUTCAR | tail -n 1 | awk '{print $4}'`
		sig9=`grep "in kB" ./2.elastic/vasp${i}2/OUTCAR | tail -n 1 | awk '{print $5}'`
		sig10=`grep "in kB" ./2.elastic/vasp${i}2/OUTCAR | tail -n 1 | awk '{print $6}'`
		sig11=`grep "in kB" ./2.elastic/vasp${i}2/OUTCAR | tail -n 1 | awk '{print $7}'`
		sig12=`grep "in kB" ./2.elastic/vasp${i}2/OUTCAR | tail -n 1 | awk '{print $8}'`
	echo "${i},${sig1},${sig2},${sig3},${sig4},${sig5},${sig6},${sig7},${sig8},${sig9},${sig10},${sig11},${sig12}">>./Elastic_stress.csv
done
python Stress2Elastic.py
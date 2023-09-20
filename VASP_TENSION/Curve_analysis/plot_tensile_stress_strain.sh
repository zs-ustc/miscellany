#!/bin/bash
workspace=tension


paste ../${workspace}/strainx.dat ../${workspace}/stressx.dat > strain_stress_x.dat
python plot_tensile_stress_strain.py strain_stress_x.dat --title 'tensile direction: x' --Yn 3 -t y --I2D 1 --label 'DFT-x:fitting'


paste ../${workspace}/strainy.dat ../${workspace}/stressy.dat > strain_stress_y.dat
python plot_tensile_stress_strain.py strain_stress_y.dat --title 'tensile direction: y' --Yn 3 -t y --I2D 1 --label 'DFT-y:fitting'


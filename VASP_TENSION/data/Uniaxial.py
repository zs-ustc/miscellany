#!/bin/bash/python
# This code is aim at making the uni-axial tensile test be automatic.
# Shuai Zhao @ Jul 18th, 2022
import numpy as np
import os
import time
import sys

def gen_poscar_from_contcar(path_input,path_output,dir_deform,start_strain,n_stage,strain_interval):
    # Generate POSCAR from CONTCAR by applying a strain tensor.
    # 1. Get the box information from CONTACAR and store in the variable 'box'
    box = np.zeros(9).reshape(3, 3)
    filename=path_input+'CONTCAR'
    #filename = './POSCAR_relaxed'  # folder = './' + str(61).zfill(3) + '/1.relax/'
    with open(filename, 'r') as file:
        line = file.readline()
        counts = 1
        while line:
            if counts <= 5:
                if counts >= 3:
                    str_ = line.split()
                    for i in range(3):
                        box[counts - 3, i] = float(str_[i])
                line = file.readline()
                counts += 1
            else:
                break
    #print(box)
    # 2. Deform the box with strain tensor and store in the variable 'box_new'
    box_new = box*1.
    if dir_deform == 1 :
        box_new[:,0]=box_new[:,0]/(1.+start_strain+strain_interval*n_stage)*(1.+start_strain+strain_interval*(n_stage+1))
    elif dir_deform == 2:
        box_new[:, 1] = box_new[:, 1] / (1. + start_strain+strain_interval * n_stage) * (1. + start_strain+strain_interval * (n_stage + 1))
    elif dir_deform == 3:
        box_new[:, 2] = box_new[:, 2] / (1. + start_strain+strain_interval * n_stage) * (1. + start_strain+strain_interval * (n_stage + 1))
    else:
        print('Wrong direction!')
    #print(start_strain + (n_stage+1) * strain_interval)  
    #print('box_new\n',box_new)
    # 3. Copy CONTCAR and Write to new POSCAR.
    folder = './POSCAR/'
    if not os.path.exists(folder):
        os.makedirs(folder)
    filename_out = folder + 'POSCAR'+path_output[4:-1]
    f = open(filename_out, 'w')
    with open(filename, 'r') as file:
        line = file.readline()
        counts = 1
        while line:
            if 5 >= counts >= 3:
                coord = np.array(box_new[counts - 3, :])
                f.write(
                    '{} {} {}\n'.format(format(coord[0], '16.9f'), format(coord[1], '16.9f'), format(coord[2], '16.9f')))
            else:
                f.write(line)
            line = file.readline()
            counts += 1
    f.close()

# Main progress
# 1. global settings
# Tensions related
import os
path_cwd = os.getcwd()
cur_filename = path_cwd.split("/")[-1]
if cur_filename[0] == 'x':
    dir_deform = 1
elif cur_filename[0] == 'y':
    dir_deform = 2
elif cur_filename[0] == 'z':
    dir_deform = 3
else:
    print('Warning: Cannot get the direction in the name of diretory!\nRemember to specify the deformation direction!!!')
    dir_deform = np.nan
I2D=0
if len(sys.argv) >= 2:
    I2D=sys.argv[1]
if len(sys.argv) >= 3:
    batch_type=sys.argv[2]

#dir_deform = 1 # 1 denotes x while 2 denotes y. Codes here is used for 2-D material. Later I'd add the z directory.
#print(dir_deform)
strain_interval = 0.01
start_strain = 0.00
max_step = 40
# Automatics related
# n_jobs = 1
time_interval = 60 # units: second
total_time = 1*24*60*60
circle_index = 0
# Main loop
for n_stage in range(max_step):
    pre_strain = start_strain + (n_stage) * strain_interval
    cur_strain = start_strain + (n_stage+1) * strain_interval
    path_input = "vasp" + str(round(pre_strain*10000)).zfill(4)+"/"
    path_output = "vasp" + str(round(cur_strain*10000)).zfill(4)+"/"
    #print(cur_filename,':',path_output)
    while True:
        circle_index += 1
        if os.path.exists(path_input+"finished"):
            os.system("python read_stress_strain_current.py "+path_input[0:-1]+" 1 ")
            file_path="../data/stress2D_current"+cur_filename[0]+".dat"
            command = f'tail -n 1 {file_path}'
            stress_input = os.popen(command).read().strip()
            print("stress of ", path_input," is: ", stress_input)
            print("Current stage: ",n_stage)
            sys.stdout.flush()
            if (n_stage>5 and stress_input<1):
                print("Last stress is very small, Chech if it is broken")
                os.system("python read_stress_strain.py")
                os.system("cp %s.jpg ../data/"%(cur_filename[0]))
                print("Stress-strain data has been saved in ../data/")
                sys.exit(1)
            gen_poscar_from_contcar(path_input,path_output,dir_deform,start_strain,n_stage,strain_interval)
            os.system("mkdir "+path_output)
            os.system("cp ./input/INCAR "+path_output+"INCAR")
            OPTCELL_str = "cp ./input/OPTCELL%d " + path_output + "OPTCELL"
            os.system(OPTCELL_str%(dir_deform)) 
            os.system("cp ./input/vasp.sub " + path_output+str(round(cur_strain*10000)).zfill(4)+".sub")
            os.system("cp ./POSCAR/POSCAR"+path_output[4:-1] + " " + path_output+"POSCAR")
            os.system("ln -s ../input/POTCAR "+ path_output)
            os.system("mv "+path_input+"WAVECAR "+path_output)
            #os.system("cd "+path_output+";sbatch *.sub"+";cd ..")
            if (batch_type == 'sh'):
                os.system("cd "+path_output+"&&sh *.sub > %s.out 2>&1"%(str(round(cur_strain*10000)).zfill(4))+" &&cd ..")
                #os.system('echo "sh *.sub > %s.out 2>&1 &"'%(str(round(cur_strain*10000)).zfill(4)))
            else:
                os.system("%s *.sub"%(batch_type))
            os.system("python read_stress_strain.py")
            os.system("cp %s.jpg ../data/"%(cur_filename[0]))
            break
        elif os.path.exists(path_input+"terminated"):
            print('Very bad news!!! Last job is terminated')
            sys.exit(1)
        else:
            time.sleep(time_interval)
        if (circle_index > total_time/time_interval):
            sys.exit(1)
    print("Job is submitted! Current directory: "+path_output)
    
print("Strain has reaches its maximum setting of",cur_strain)
os.system("python read_stress_strain.py")
os.system("cp %s.jpg ../data/"%(cur_filename[0]))
print("Stress-strain data has been saved in ../data/")



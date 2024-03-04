# Shuai Zhao @ Jun 02, 2022
# This python code is for ...
#
import numpy as np
import os

# 1. Read box information from CONTCAR
box = np.zeros(9).reshape(3,3)
filename = '../1.relax/CONTCAR' #folder = './' + str(61).zfill(3) + '/1.relax/'
with open(filename,'r') as file:
    line = file.readline()
    counts = 1
    while line:
        if counts <= 5:
            if counts >= 3:
                str_ = line.split( )
                for i in range(3):
                    box[counts-3,i] = float(str_[i])
            line = file.readline()
            counts += 1
        else:
            break
print(box)

# 2. Deform
# Six directions should under concern.

# Get deformed box information
strain = 0.003 / 2
for dir in range(1,7):
    strain_vector = np.zeros(6)
    for plus_minus in range(1,3):
        if plus_minus == 1:
            strain_pm = strain * 1.0
        else:
            strain_pm = strain * -1.0
        strain_vector[dir-1] = strain_pm
        strain_matrix = np.array([strain_vector[0]+1.,strain_vector[5]/2,strain_vector[4]/2,strain_vector[5]/2,strain_vector[1]+1.,strain_vector[3]/2,strain_vector[4]/2,strain_vector[3]/2,strain_vector[2]+1.]).reshape(3,3)
        box_new = np.matmul(box,strain_matrix)
        print(dir, '\n', box_new)

        '''if dir == 2:
            dir_real=4
        elif dir == 3:
            dir_real = 6
        elif dir == 4:
            dir_real = 2
        elif dir == 6:
            dir_real = 3
        else:
            dir_real = dir
        for plus_minus in range(1,3):

            if plus_minus == 1:
                strain_pm = strain * 1.0
            else:
                strain_pm = strain * -1.0
            if dir <= 3:
                dir_1 = 0
                dir_2 = dir-1
            elif dir <=5:
                dir_1 = 1
                dir_2 = dir-3
            else:
                dir_1 = 2
                dir_2 = dir-4
            box_deform = np.zeros(3).reshape(3,1)
            box_deform[:,0] = box[:, dir_1] * strain_pm
            box_new = box + 0.0
            box_new[:,dir_2] += box_deform[:,0]
            print(dir, '\n', box_new)'''

        # Copy CONTCAR and Write to new POSCAR.
        # Specialize POSCAR File path and file name
        folder = './POSCAR/'
        if not os.path.exists(folder):
            os.makedirs(folder)
        filename_out = folder +  'POSCAR' + str(dir) + str(plus_minus)
        f = open(filename_out,'w')
        with open(filename,'r') as file:
            line = file.readline()
            counts = 1
            while line:
                if 5 >= counts >= 3:
                    coord = np.array(box_new[counts-3, :])
                    f.write('{} {} {}\n'.format(format(coord[0], '16.9f'), format(coord[1], '16.9f'), format(coord[2], '16.9f')))
                else:
                    f.write(line)
                line = file.readline()
                counts += 1
        f.close()

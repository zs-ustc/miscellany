# For results of
import fileinput
import os
from subprocess import PIPE, Popen
import matplotlib.pyplot as plt
import matplotlib as mpl
import sys

def cmdline(command):
    process = Popen(
        args=command,
        stdout=PIPE,
        shell=True
    )
    return process.communicate()[0]

path_cwd = os.getcwd()
#print(path_cwd)
cur_filename = path_cwd.split("/")[-1]
#print(cur_filename[0])
if cur_filename[0] == 'x':
    dir_deform = 1
elif cur_filename[0] == 'y':
    dir_deform = 2
elif cur_filename[0] == 'z':
    dir_deform = 3
else:
    print('Warning: Remember to specify the deformation direction!!!')
os.system("mkdir -p ../data")

dir_vasp='./'
if len(sys.argv) >= 2:
    dir_vasp=sys.argv[1]
I2D=0
if len(sys.argv) >= 3:
    I2D=sys.argv[2]


if os.path.isdir(dir_vasp):
    if dir_vasp[0:4] == "vasp" and os.path.exists(dir_vasp+"/finished"):
        strain_i = int(dir_vasp[4:])*1.0/100
        if dir_deform == 1:
            stress_i = cmdline("grep 'in kB' %s/OUTCAR | tail -n 1 | awk '{print $3}'"%dir_vasp)
        elif dir_deform == 2:
            stress_i = cmdline("grep 'in kB' %s/OUTCAR | tail -n 1 | awk '{print $4}'"%dir_vasp)
        elif dir_deform == 3:
            stress_i = cmdline("grep 'in kB' %s/OUTCAR | tail -n 1 | awk '{print $5}'"%dir_vasp)
        stress_i = float(stress_i)*(-0.1)
if I2D != 0:
    f_strain=open("../data/strain2D_current"+cur_filename[0]+".dat",'a')
    f_strain.write(str(strain_i)+'\n')
else:
    f_strain=open("../data/strain_current"+cur_filename[0]+".dat",'a')
    #f_strain.write('strain(%)\n')
    f_strain.write(str(strain_i)+'\n')
f_strain.close()
if I2D != 0:
    f_stress=open("../data/stress2D_current"+cur_filename[0]+".dat",'a')
    file_path=dir_vasp+"/CONTCAR"
    
    # get c
    with open(file_path, 'r') as file:
        lines = file.readlines()
    if len(lines) >= 5:
        words = lines[4].split()
        if len(words) >= 3:
            ###### make sure the scaling factor in POSCAR is 1!!!!!!!!!!
            c = float(words[2])
            #print("c =", c)
        else:
            print("The 5th line does not contain at least 3 words")
    else:
        print("The file does not contain at least 5 lines")
    #c=15
    stress_i=stress_i*c/10
    f_stress.write('%.6f' % stress_i+'\n')
else:
    f_stress=open("../data/stress_current"+cur_filename[0]+".dat",'a')
    f_stress.write('%.6f' % stress_i+'\n')
f_stress.close()

#plt.switch_backend('agg')
#plt.style.use('default')
##mpl.rcParams['font.family'] = 'arial'
#mpl.rcParams['font.size'] = 12.0
#mpl.rcParams['axes.labelsize'] = 12.0
#mpl.rcParams['legend.fontsize'] = 12.0
#mpl.rcParams['legend.loc'] = 'best'
#mpl.rcParams['figure.figsize'] = [5.00, 4.00]
#mpl.rcParams['figure.facecolor'] = 'w'
#mpl.rcParams['figure.dpi'] =  300
#mpl.use('Agg')
#fig, ax = plt.subplots()
## data=np.loadtxt('TRANSMISSION_2D.dat',dtype=np.float64)
## ax.plot(data[:,0], data[:,1], linestyle = '-', linewidth = 1.50, color = 'b', label = 'x')
## ax.plot(data[:,0], data[:,2], linestyle = '-', linewidth = 1.50, color = 'g', label = 'y')
#ax.plot(strain, stress, linestyle = '-', linewidth = 1.50, color = 'b', label = 'lx')
#ax.scatter(strain, stress, marker='+', color = 'coral')
## ax.scatter(strain, stress)
#ax.set_xlabel(r'Strain (%)')
#ax.set_ylabel(r'Stress (GPa)')
#plt.tight_layout()
#plt.savefig(cur_filename[0]+'.jpg')
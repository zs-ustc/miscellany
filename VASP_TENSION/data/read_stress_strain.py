# For results of
import fileinput
import os
import sys
from subprocess import PIPE, Popen
import matplotlib.pyplot as plt
import matplotlib as mpl

def cmdline(command):
    process = Popen(
        args=command,
        stdout=PIPE,
        shell=True
    )
    return process.communicate()[0]

I2D=0
if len(sys.argv) >= 2:
    I2D=sys.argv[1]

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

strain = []
stress = []   
for dir_vasp in os.listdir("."):
    if os.path.isdir(dir_vasp):
        if dir_vasp[0:4] == "vasp" and os.path.exists(dir_vasp+"/finished"):
            strain_i = int(dir_vasp[4:])*1.0/100
            strain.append(strain_i)
            if dir_deform == 1:
                stress_i = cmdline("grep 'in kB' %s/OUTCAR | tail -n 1 | awk '{print $3}'"%dir_vasp)
            elif dir_deform == 2:
                stress_i = cmdline("grep 'in kB' %s/OUTCAR | tail -n 1 | awk '{print $4}'"%dir_vasp)
            elif dir_deform == 3:
                stress_i = cmdline("grep 'in kB' %s/OUTCAR | tail -n 1 | awk '{print $5}'"%dir_vasp)
            stress_i = float(stress_i)*(-0.1)
            stress.append(stress_i)
            if I2D != 0:
                # get c
                with open(dir_vasp+"/CONTCAR", 'r') as file:
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
strain,stress = (list(t) for t in zip(*sorted(zip(strain,stress))))
f_strain=open("../data/strain"+cur_filename[0]+".dat",'w')
f_strain.write('strain(%)\n')
for line in strain:
    f_strain.write(str(line)+'\n')
f_strain.close()
f_stress=open("../data/stress"+cur_filename[0]+".dat",'w')
if I2D != 0:
    for i in range(len(stress)):
        stress[i] *= c/10.0
    f_stress.write('stress(N/m)\n')
    for line in stress:
        f_stress.write('%.6f' % line+'\n')
else:
    f_stress.write('stress(GPa)\n')
    for line in stress:
        f_stress.write('%.6f' % line+'\n')
f_stress.close()

plt.switch_backend('agg')
plt.style.use('default')
#mpl.rcParams['font.family'] = 'arial'
mpl.rcParams['font.size'] = 12.0
mpl.rcParams['axes.labelsize'] = 12.0
mpl.rcParams['legend.fontsize'] = 12.0
mpl.rcParams['legend.loc'] = 'best'
mpl.rcParams['figure.figsize'] = [5.00, 4.00]
mpl.rcParams['figure.facecolor'] = 'w'
mpl.rcParams['figure.dpi'] =  300
mpl.use('Agg')
fig, ax = plt.subplots()
# data=np.loadtxt('TRANSMISSION_2D.dat',dtype=np.float64)
# ax.plot(data[:,0], data[:,1], linestyle = '-', linewidth = 1.50, color = 'b', label = 'x')
# ax.plot(data[:,0], data[:,2], linestyle = '-', linewidth = 1.50, color = 'g', label = 'y')
ax.plot(strain, stress, linestyle = '-', linewidth = 1.50, color = 'b', label = 'lx')
ax.scatter(strain, stress, marker='+', color = 'coral')
# ax.scatter(strain, stress)
ax.set_xlabel(r'Strain (%)')
if I2D != 0:
    ax.set_ylabel(r'Stress (N/m)')
else:
    ax.set_ylabel(r'Stress (GPa)')
plt.tight_layout()
plt.savefig(cur_filename[0]+'.jpg')
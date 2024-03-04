# Shuai Zhao @ Jun 02, 2022
# This python code is for ...
#
import pandas as pd
import numpy as np

np.set_printoptions(suppress=True)

strain=0.003
# Read stress data
Stress_dir_df=pd.read_csv('./Elastic_stress.csv', header=0,index_col=0)
Stress_dir=np.array(Stress_dir_df)/10.0
C_all = np.zeros(36).reshape(6,6)
C_sym = C_all * 1.0

# Calculate C tensor and S tensor by stress and strain
for i in range(6):
    for j in range(6):
        C_all[i,j]=(Stress_dir[i,j+6] - Stress_dir[i,j])/strain
        if i==j:
            C_sym[i,j] = C_all[i,j]
        else:
            C_sym[i,j] = C_all[i,j]/2+C_all[j,i]/2
            C_sym[j,i] = C_all[i,j]/2+C_all[j,i]/2
C_all_print = np.around(C_all, decimals=4)
C_sym_print = np.around(C_sym, decimals=4)
print(C_all_print)
print(C_sym_print)
np.savetxt('Elastic_Tensor',C_sym_print,fmt='%f')
'''
S_all = np.linalg.inv(C_all)
print(np.around(S_all, decimals=4))
'''
# Print critical parameters
for i in range(3):
    print('C'+str(i+1)+str(i+1),'  ',C_all[i,i])
print('C12   ',C_all[0,1],C_all[1,0],'\nC23   ',C_all[1,2],C_all[2,1],'\nC13   ',C_all[2,0],C_all[0,2])
for i in range(3,6):
    print('C'+str(i+1)+str(i+1),'  ',C_all[i,i])

'''
# Calculate Bulk modulus and shear modulus
C11_cubic = (C_all[0,0]+C_all[1,1]+C_all[2,2])/3.0
C12_cubic = (C_all[0,1]+C_all[1,0]+C_all[1,2]+C_all[2,1]+C_all[0,2]+C_all[2,0])/6.0
C44_cubic = (C_all[4,4]+C_all[5,5]+C_all[3,3])/3.0

S11_cubic = (S_all[0,0]+S_all[1,1]+S_all[2,2])/3.0
S12_cubic = (S_all[0,1]+S_all[1,0]+S_all[1,2]+S_all[2,1]+S_all[0,2]+S_all[2,0])/6.0
S44_cubic = (S_all[4,4]+S_all[5,5]+S_all[3,3])/3.0

bulk_modulus_V = (C11_cubic + 2 * C12_cubic) / 3
bulk_modulus_R = 1. / (3 * S11_cubic + 6 * S12_cubic)
bulk_modulus = (bulk_modulus_V + bulk_modulus_R) / 2

shear_modulus_V = (C11_cubic - C12_cubic) / 5 + C44_cubic *3 / 5
shear_modulus_R = 15 / ((S11_cubic - S12_cubic) *12 + S44_cubic * 9)
shear_modulus = (shear_modulus_V + shear_modulus_R) / 2

print('Bulk Modulus V= {} GPa\nBulk Modulus R= {} GPa\nShear Modulus V = {} GPa\nShear Modulus R = {} GPa'
      .format(format(bulk_modulus_V, '.2f'), format(bulk_modulus_R, '.2f'), format(shear_modulus_V, '.2f'), format(shear_modulus_R, '.2f')))

# Calculate Hardness and print
Hard_v = (2.0 * (shear_modulus ** 3 / bulk_modulus ** 2 ) ** 0.585 - 3.0) / 0.009807
print('Vickers Hardness = {} HV'.format(format(Hard_v, '.2f')))
'''


# Shuai Zhao @ Jun 11, 2023
# This python code is for the validation the script 'chgsum.pl' of VTST
#
import numpy as np
import os

n_lines=12
with open("AECCAR0") as CHGCAR1:
    with open("AECCAR2") as CHGCAR2:
        with open("sum_zs.CHGCAR","w") as CHGSUM:
            for i_iter in range(n_lines):
                a=CHGCAR1.readlines(1)[0].strip("\n")
                b=CHGCAR2.readlines(1)[0].strip("\n")
                CHGSUM.write(a+"\n")
            while True:
                a = CHGCAR1.readlines(1)[0].strip("\n")
                b = CHGCAR2.readlines(1)[0].strip("\n")
                if not a:
                    break
                a_list = a.split()
                b_list = b.split()
                if len(a_list)<5:
                    break
                c_float = []
                for i in range(len(a_list)):
                    c_float.append(float(a_list[i]) + float(b_list[i]))
                CHGSUM.write(" %.10e" % (c_float[0])+ " %.10e" % (c_float[1])+ " %.10e" % (c_float[2])+ " %.10e" % (c_float[3])+
                      " %.10e" % (c_float[4])+"\n")

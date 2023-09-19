#### Perform a HSE06 calculation easily:
###### 0. VASP and vaspkit toolkit are required to install properly.

###### 1. Perform a PBE self-consistent
echo -e "302\n" | vaspkit # Get KPATH.in
echo -e "251\n2\n0.03\n0.05\n" | vaspkit # Get KPOINTS
> submit the job
echo -e "252\n" | vaspkit # get BAND STRUCTURE by PBE exchange-correlation functional.

###### 2. HSE self-consistent
> Change INCAR (add the HSE06 part) and submit the job
echo -e "911\n" | vaspkit # get BAND_GAP
echo -e "252\n" | vaspkit # get BAND STRUCTURES of HSE06 hybrid functional.

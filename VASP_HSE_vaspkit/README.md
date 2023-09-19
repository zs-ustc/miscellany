## Easy perform an HSE06 calculation.
### 0. VASP and vaspkit toolkit are required to install properly.

### 1. Perform a PBE self-consistent.
1. Get KPATH.in:   
  `echo -e "302\n" | vaspkit`   
2. Get KPOINTS with and without weights:  
  `echo -e "251\n2\n0.03\n0.05\n" | vaspkit` 
3. Submit the job.   
4. Get BAND STRUCTURE by PBE exchange-correlation functional.  
  `echo -e "252\n" | vaspkit`  

### 2. HSE self-consistent.
1. Change INCAR (add the HSE06 part) and submit the job.
2. Get BAND_GAP:  
`echo -e "911\n" | vaspkit`
3. Get BAND STRUCTURES of HSE06 hybrid functional:  
`echo -e "252\n" | vaspkit`


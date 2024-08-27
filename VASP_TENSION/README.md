## VASP Uniaxial Tension Calculation Documentation

### Introduction
This document describes how to sequentially run VASP calculations for uniaxial tension. Each shell script corresponds to a calculation step: structural optimization, preparation of input files, and uniaxial tension calculation.

### Files Overview
This documentation covers the following three scripts:
1. `step0_optimize.sh`: Perform structural optimization
2. `step1_prepare.sh`: Prepare necessary input files
3. `step2_stretch.sh`: Perform uniaxial tension calculation

### Prerequisites
- VASP and VASPKIT installed
- Python installed
- Properly configured batch processing system (e.g., SLURM)

### Usage Instructions

#### 1. `step0_optimize.sh` - Structural Optimization
This script performs the initial structural optimization calculation.

##### Execution Steps
1. Ensure the `data/` directory contains the following files:
   - POSCAR file (`POSCAR_dir/POSCAR_filename`)
   - `INCAR.isif3`
   - `vasp_relax.sub`
2. Run the script:
   ```sh
   bash step0_optimize.sh
   ```

#### 2. `step1_prepare.sh` - Prepare Input Files
This script prepares the input files required for the tension calculations.


##### Execution Steps
1. Ensure the `data/` directory contains the following files:
   - `POSCAR`
   - `INCAR.isif2`
   - `INCAR.scf`
   - `INCAR.isif3`
   - `vasp.sub`
2. Run the script:
   ```sh
   bash step1_prepare.sh
   ```

#### 3. `step2_stretch.sh` - Uniaxial Tension Calculation
This script performs the uniaxial tension calculation.


##### Execution Steps
1. Ensure the `data/` directory contains the following files:
   - `Uniaxial.py`
   - `read_stress_strain.py`
   - `read_stress_strain_current.py`
   - Necessary files generated from previous steps
2. Run the script:
   ```sh
   bash step2_stretch.sh
   ```

### Notes
- Ensure all necessary files are located in the `data/` directory.
- Before running each script, check that the parameter settings in the script match the actual conditions.
- If using a 3D system instead of 2D, modify the I2D variable (I2D=0) at the beginning of the shell scripts.
- The scripts assume they are run in the same directory and in the specified order.

### FAQ
**Q: Why can't the script find the necessary files?**
A: Ensure that all required files are located in the `data/` directory and that the filenames match those specified in the script.

**Q: How do I check the type of batch processing system?**
A: The scripts default to using `sbatch`. If using a different system (e.g., `sh` or `qsub`), modify the `batch_type` variable at the beginning of the script.

**Q: How do I monitor the running status and results?**
A: The scripts generate output files. Check the respective `.out` files for detailed running information.

## VASP 单轴拉伸计算说明文档

### 简介
此文档介绍了如何运行 VASP 计算单轴拉伸。主目录下每个shell脚本对应一个计算步骤，分别是结构优化、输入文件准备和单轴拉伸计算。

### 文件说明
本说明涵盖以下三个脚本文件：
1. `step0_optimize.sh`: 进行结构优化计算
2. `step1_prepare.sh`: 准备必要的输入文件
3. `step2_stretch.sh`: 进行单轴拉伸计算

### 先决条件
- 安装了 VASP 和 VASPKIT
- 安装了 Python
- 已配置合适的批处理系统（例如 SLURM）

### 使用方法

#### 1. `step0_optimize.sh` - 结构优化
这个脚本进行初始结构的优化计算。

##### 执行步骤
1. 确保 `data/` 目录中包含以下文件：
   - POSCAR 文件 (`POSCAR_dir/POSCAR_filename`)
   - `INCAR.isif3`
   - `vasp_relax.sub`
2. 运行脚本：
   ```sh
   bash step0_optimize.sh
   ```

#### 2. `step1_prepare.sh` - 准备输入文件
这个脚本用于准备拉伸计算所需的输入文件。

##### 执行步骤
1. 确保 `data/` 目录中包含以下文件：
   - `POSCAR`
   - `INCAR.isif2`
   - `INCAR.scf`
   - `INCAR.isif3`
   - `vasp.sub`
2. 运行脚本：
   ```sh
   bash step1_prepare.sh
   ```

#### 3. `step2_stretch.sh` - 单轴拉伸计算
这个脚本用于进行单轴拉伸计算。

##### 执行步骤
1. 确保 `data/` 目录中包含以下文件：
   - `Uniaxial.py`
   - `read_stress_strain.py`
   - `read_stress_strain_current.py`
   - 之前步骤生成的必要文件
2. 运行脚本：
   ```sh
   bash step2_stretch.sh
   ```

### 注意事项
- 确保所有必要的文件都位于 `data/` 目录中。
- 每个脚本在运行之前，先检查脚本中的参数设置是否符合实际情况。
- 如果二维体系，需要修改shell脚本开头的I2D参数(I2D=0)。
- 脚本假定在同一目录下运行，并且按照顺序执行。

### 常见问题
**Q: 为什么脚本无法找到必要的文件？**
A: 请确保 `data/` 目录中包含所有必需的文件，并且文件名与脚本中的设置匹配。

**Q: 如何检查批处理系统的类型？**
A: 脚本默认使用 `sbatch`，如果使用其他类型（如 `sh` 或 `qsub`），请在脚本开头修改 `batch_type` 变量。

**Q: 如何查看运行状态和结果？**
A: 脚本会生成输出文件，检查相应的 `.out` 文件以获取详细的运行信息。



# VASP计算弹性常数
利用应力应变方法，只计算十二个VASP任务，可以得到36个弹性常数。
该方法经过多次验证与使用，只需要注意一点，VASP计算弹性常数时晶格常数不能过小（<5 Angstrom），需要适当扩胞。

### 计算前必需的的文件
1. 脚本文件：
 1. pre.sh: 自动前处理的shell脚本。
 2. post.sh: 自动后处理的shell脚本。
 3. deform.py: 对弛豫后结构（./1.relax/CONTCAR）施加应变的python程序。
 4. Stress2Elastic.py: 对得到的应力进行计算为弹性常数的python程序，需要在程序中指定施加的应变大小，与deform.py中一致。应变推荐范围（0.1%-1%）。
2. 需要提供的文件：
 1. 1.relax: 将结构弛豫的文件夹命名为1.relax, 与脚本文件放在同一目录下。
 2. INCAR.isif2: 只优化原子位置（ISIF=2）的INCAR文件，这里提供了示例。
 3. vasp.sub: 提交VASP计算程序到队列的脚本。根据提交方法的不同，需要对pre.sh中‘sbatch *.sub’进行调整。这里提供了slurm的示例。

###计算流程
1. 运行sh pre.sh，将对弛豫结构施加六个方向正负两个应变。随后产生计算文件夹，例如2.elastic/vasp11，指的是1方向的正应变。最后通过vasp.sub将12个计算任务提交到计算队列。
2. 计算结束后运行sh post.sh, 将会自动收集计算后的应力结果，并将结果储存在Elastic_Tensor中。
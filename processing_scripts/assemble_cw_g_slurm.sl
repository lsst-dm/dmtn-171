#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 6
#SBATCH -n 26
#SBATCH -t 140:00:00
#SBATCH -J cwGAssem

srun --output slurm_cw/job%j-g-%2t.out --ntasks=26 --multi-prog assemble_cw_g_slurm.conf

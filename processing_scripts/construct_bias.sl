#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 10:00:00
#SBATCH -J sahaBias

srun --output slurm_calib/job%j-%2t.out --ntasks=1 --multi-prog construct_bias.conf

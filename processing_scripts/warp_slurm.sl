#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 2
#SBATCH -n 8
#SBATCH -t 120:00:00
#SBATCH -J sahaWarp

srun --output slurm_warp/job%j-%2t.out --ntasks=8 --multi-prog warp_slurm.conf


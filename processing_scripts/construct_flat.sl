#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J sahaFlat

srun --output slurm_calib/job%j-%2t.out --ntasks=4 --multi-prog construct_flat.conf

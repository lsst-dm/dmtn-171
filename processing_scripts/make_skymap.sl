#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J skymap

srun --output slurm_warp/job%j-%2t.out --ntasks=2 --multi-prog make_skymap.conf


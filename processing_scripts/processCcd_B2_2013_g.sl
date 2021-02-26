#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 2
#SBATCH -n 8
#SBATCH -t 36:00:00
#SBATCH -J B2_13_g

srun --output slurm_pccd/job%j-B2_2013_g_%2t.out --ntasks=8 --multi-prog processCcd_B2_2013_g.conf

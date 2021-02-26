#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 3
#SBATCH -n 18
#SBATCH -t 48:00:00
#SBATCH -J B1_13_i

srun --output slurm_pccd/job%j-B1_2013_i_%2t.out --ntasks=18 --multi-prog processCcd_B1_2013_i.conf

#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 2
#SBATCH -n 9
#SBATCH -t 36:00:00
#SBATCH -J B1_13_g

srun --output slurm_pccd/job%j-B1_2013_g_%2t.out --ntasks=9 --multi-prog processCcd_B1_2013_g.conf  

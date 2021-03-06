#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 2
#SBATCH -n 11
#SBATCH -t 36:00:00
#SBATCH -J B1_15_g

srun --output slurm_pccd/job%j-B1_2015_g_%2t.out --ntasks=11 --multi-prog processCcd_B1_2015_g.conf

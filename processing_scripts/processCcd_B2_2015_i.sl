#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 3
#SBATCH -n 15
#SBATCH -t 24:00:00
#SBATCH -J B2_15_i

srun --output slurm_pccd/job%j-B2_2015_i_%2t.out --ntasks=15 --multi-prog processCcd_B2_2015_i.conf

#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 3
#SBATCH -n 17
#SBATCH -t 48:00:00
#SBATCH -J B2_13_i

srun --output slurm_pccd/job%j-B2_2013_i_%2t.out --ntasks=17 --multi-prog processCcd_B2_2013_i.conf

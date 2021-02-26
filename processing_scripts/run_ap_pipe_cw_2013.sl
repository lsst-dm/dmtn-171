#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 4
#SBATCH -n 12
#SBATCH -t 240:00:00
#SBATCH -J saApCw13

# To submit a slurm job:
#       $ sbatch run_ap_pipe.sl

srun --output slurm_ap_cw_2013/ap_pipe_%j-%2t.out --ntasks=12 --multi-prog run_ap_pipe_cw_2013.conf



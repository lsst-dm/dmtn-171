#!/bin/bash -l

#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 0:29:00
#SBATCH -J sahaICal

srun --output slurm_calib/job%j-%2t.out --ntasks=1 --multi-prog initial_calibration.conf
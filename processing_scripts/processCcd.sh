#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib

decam_repo='/datasets/decam/'
output='processed_data/'

visit_list=$1
processCcd.py ${decam_repo} --calib calib --output ${output} --id ${visit_list} -C processCcd_config.py -C $2 --clobber-config --clobber-versions

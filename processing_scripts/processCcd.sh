#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib
# setup -r /project/sullivan/code/pipe_tasks
setup -r /project/sullivan/code/ip_isr -j

decam_repo='/datasets/decam/'
output='processed_data/'

visit_list=$1
processCcd.py ${decam_repo} --calib calib --output ${output} --id ${visit_list} -C processCcd_config.py -C $2 --clobber-config --clobber-versions

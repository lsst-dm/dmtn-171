#!/bin/bash

# This script is called by run_ap_pipe.conf, which is called by run_ap_pipe.sl

# HEY YOU!!!
# BEFORE YOU SBATCH ANYTHING, YOU NEED TO MAKE AN EMPTY APDB!!! e.g.,
# make_apdb.py -c apdb.isolation_level=READ_UNCOMMITTED -c apdb.db_url="sqlite:////project/mrawls/hits2015/rerun/$rerun/association.db"

# Set up the stack and necessary ap_packages
source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib
# setup -r /project/sullivan/code/ip_diffim
setup -r /project/sullivan/code/ip_isr -j

# Config stuff
calib="calib"
output_repo="/project/sullivan/saha2/ap_pipe_slow/cw_2013"
template="cwcoadds_2015"

# make_apdb.py -c isolation_level=READ_UNCOMMITTED -c db_url="sqlite:///"${output_repo}"/association.db" &

db_config=(-c diaPipe.apdb.db_url="sqlite:///"${output_repo}"/association.db" -c diaPipe.apdb.isolation_level="READ_UNCOMMITTED" -c diaPipe.apdb.connection_timeout=1200)
more_config=(-c ccdProcessor.calibrate.photoCal.match.referenceSelection.magLimit.fluxField="i_flux" -c ccdProcessor.calibrate.photoCal.match.referenceSelection.magLimit.maximum=22.0)
filter_specific_config=$2

visit_id=$1

# Command to run
ap_pipe.py /datasets/decam --calib ${calib} --template ${template} --output ${output_repo} "${db_config[@]}" "${more_config[@]}" -C ap_pipe_config.py -C $filter_specific_config --id @$visit_id  --clobber-versions --clobber-config

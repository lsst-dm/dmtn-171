#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib
# setup -r /project/sullivan/code/obs_decam -j

decam_repo='/datasets/decam/'
configs="isr.doDark=False isr.biasDataProductName=bias"

constructFlat.py ${decam_repo} --calib calib --output calib_construction --id $1 --config ${configs} --batch-type none --clobber-config --clobber-versions

ingestCalibs.py ${decam_repo} --calib calib --mode=link --validity 999 calib_construction/FLAT/$2/*.fits

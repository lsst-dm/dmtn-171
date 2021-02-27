#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib

decam_repo='/datasets/decam/'

ingestCuratedCalibs.py $decam_repo --calib calib $OBS_DECAM_DATA_DIR/decam/defects
ingestCuratedCalibs.py $decam_repo --calib calib $OBS_DECAM_DATA_DIR/decam/crosstalk

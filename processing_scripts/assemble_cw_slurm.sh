#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib

input="warped_exposures"
output="cwcoadds_processed"
assembleConfig="doInterp=True doNImage=True"
assembleId="tract=0"  # patch is set by $1, filter by $2, and the visit list by $3

assembleCoadd.py ${input} --output ${output} --warpCompareCoadd --selectId $2 $3 --id ${assembleId} $1 $2 --config ${assembleConfig} --clobber-config --clobber-versions

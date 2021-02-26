#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib

input="processed_data"
output="warped_exposures"
configs="select.nImagesMax=1000 select.maxPsfFwhm=4.2"

makeCoaddTempExp.py ${input} --output ${output} -C makeCoaddTempExp_goodSeeing.py --selectId $1 filter=$2 --id filter=$2 tract=0 --clobber-config --clobber-versions

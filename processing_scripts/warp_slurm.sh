#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib

input="/project/sullivan/saha2/processed_data"
output="/project/sullivan/saha2/warped_exposures"
configs="select.nImagesMax=1000 select.maxPsfFwhm=4.2"

makeCoaddTempExp.py ${input} --output ${output} -C makeCoaddTempExp_goodSeeing.py --selectId $1 filter=$2 --id filter=$2 tract=0 --clobber-config --clobber-versions

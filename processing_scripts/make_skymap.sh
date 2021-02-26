#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib

input="/project/sullivan/saha2/processed_data"
output="/project/sullivan/saha2/$3"
configs="skyMap.pixelScale=0.26"

makeDiscreteSkyMap.py ${input} --output ${output} --config ${configs} --id tract=0 $1 $2 --clobber-config --clobber-versions


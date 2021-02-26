#!/bin/bash

source /software/lsstsw/stack/loadLSST.bash
setup lsst_distrib

input="processed_data"
configs="skyMap.pixelScale=0.26"

makeDiscreteSkyMap.py ${input} --output $3 --config ${configs} --id tract=0 $1 $2 --clobber-config --clobber-versions


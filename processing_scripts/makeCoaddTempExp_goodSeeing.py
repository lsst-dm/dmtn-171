#from lsst.pipe.tasks.selectImages import BestSeeingWcsSelectImagesTask

# Defaults in ap_pipe config
config.bgSubtracted = True
config.coaddName='deep'
#config.select.retarget(BestSeeingWcsSelectImagesTask)
config.makePsfMatched = True
#config.makeDirect = True

## Additions by Meredith
#config.select.nImagesMax = 1000
#config.select.maxPsfFwhm = 4.2

config.charImage.requireCrForPsf=False
# Don't fail on images with a high number of cosmic ray detections, even though they are not real
config.charImage.repair.cosmicray.nCrPixelMax=10000000

config.isr.biasDataProductName='bias'
config.isr.flatDataProductName='flat'

config.calibrate.photoCal.match.referenceSelection.magLimit.fluxField="i_flux" 
config.calibrate.photoCal.match.referenceSelection.magLimit.maximum=22.0

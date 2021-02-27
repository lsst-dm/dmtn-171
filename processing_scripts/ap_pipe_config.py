config.ccdProcessor.charImage.requireCrForPsf=False
# Don't fail on images with a high number of cosmic ray detections, even though they are not real
config.ccdProcessor.charImage.repair.cosmicray.nCrPixelMax=10000000

config.ccdProcessor.isr.biasDataProductName='bias'
config.ccdProcessor.isr.flatDataProductName='flat'

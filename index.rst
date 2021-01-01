..
  Technote content.

  See https://developer.lsst.io/restructuredtext/style.html
  for a guide to reStructuredText writing.

  Do not put the title, authors or other metadata in this document;
  those are automatically added.

  Use the following syntax for sections:

  Sections
  ========

  and

  Subsections
  -----------

  and

  Subsubsections
  ^^^^^^^^^^^^^^

  To add images, add the image file (png, svg or jpeg preferred) to the
  _static/ directory. The reST syntax for adding the image is

  .. figure:: /_static/filename.ext
     :name: fig-label

     Caption text.

   Run: ``make html`` and ``open _build/html/index.html`` to preview your work.
   See the README at https://github.com/lsst-sqre/lsst-technote-bootstrap or
   this repo's README for more info.

   Feel free to delete this instructional comment.

:tocdepth: 3

.. Please do not modify tocdepth; will be fixed when a new Sphinx theme is shipped.

.. sectnum::

.. TODO: Delete the note below before merging new content to the master branch.

.. note::

   **This technote is not yet published.**

   A report on the Fall 2020 state of the LSST Alert Production Pipelines' ability to process deep images in the galactic bulge.

Introduction
============

Some of the earliest applications of image differencing in astronomy were motivated by the desire to identify transient sources (microlensing events) in extremely crowded stellar fields.
At ground-based photometric precision, typically about one percent of stellar sources have detectable variability. 
Thus by subtracting a coadded historical (template) image from a new (science) image, the crowding can be reduced by a factor of ~100.

In this technote we assess the state of crowded field processing in Fall 2020 using the LSST Alert Production (AP) Science Pipelines.
Alert Production uses image differencing to identify transient, moving, and variable sources in LSST images within 60 seconds of camera readout.
Crucially, the AP processing must meet its requirements even in the most crowded fields it will encounter.
Of particular importance are the transient reporting latency (OTT1 and OTR1; LSR-REQ-0117 and LSR-REQ-0025), 
the reliability with which images are processed (sciVisitAlertDelay and sciVisitAlertFailure; OSS-REQ-0112), 
the photometric and astrometric accuracy of the resulting catalogs (dmL1AstroErr, dmL1PhotoErr, and photoZeroPointOffset; OSS-REQ-0149 and OSS-REQ-0152), 
completeness and purity metrics for transients (OSS-REQ-0353) and solar system objects ( OSS-REQ-0354),
and source misassociation for transients (OSS-REQ-0160) and solar system objects (OSS-REQ-0159).
Accordingly, large-scale tests on precursor datasets are necessary to identify where improvements are needed in order to meet requirements.
The status of the processing also will inform ongoing cadence planning for the overall survey.

The scope of this technote does not include obtaining photometry for static sources in direct images (except insofar as it is required to conduct image differencing), nor comparisons to dedicated crowded field processing codes.
`DMTN-077 <https://dmtn-077.lsst.io>`_ addressess these issues.

Overview of the data
====================

To test the LSST Science Pipelines on crowded fields, we acquired public data from the DECam survey of the galactic bulge by `Saha et. al <https://arxiv.org/pdf/1902.05637.pdf>`_.
The full survey consists of six fields at low galactic latitudes observed in the six ``ugrizy`` bands, though for this investigation we limited the analysis to g- and i-bands for the two fields closest to the galactic center (B1 and B2, :numref:`field_coordinates`).
The two fields selected for this test were observed in 2013 and 2015 to similar depth in both bands (:numref:`visit_summary`).
These data are available on ``lsst-devl`` at ``/datasets/decam``, while the processed data and the scripts that produced them available at ``/project/sullivan/saha2``.
The size of the processed data amounts to 7.0Tb on disk, which can be fully recreated following the instructions in ``/project/sullivan/saha2/README``.

.. table:: Field coordinates
   :name: field_coordinates

   ======  ========  ========
   Field   RA        Dec
   ======  ========  ========
   B1      270.8917  -30.0339
   B2      272.3500  -31.4350
   ======  ========  ========

.. table:: Summary of visits
   :name: visit_summary
    
   ====== ====== ====== ======
   Field  band   2013   2015
   ====== ====== ====== ======
   B1       g    30     44
   B2       g    31     44
   B1       i    53     44
   B2       i    49     44
   ====== ====== ====== ======

It is important to note that the seeing was uniformly worse in 2013 than in 2015 for this survey (:numref:`seeing_B1_g` - :numref:`seeing_B2_i`).
As a result, we expect image differencing to fare much worse when running ``ap_pipe`` on the 2015 observations using the template constructed from the 2013 observations.

.. figure:: /_static/Seeing_B1_g.png
 :name: seeing_B1_g

 Distribution of seeing for g-band observations of field B1

.. figure:: /_static/Seeing_B2_g.png
 :name: seeing_B2_g

 Distribution of seeing for g-band observations of field B2

.. figure:: /_static/Seeing_B1_i.png
 :name: seeing_B1_i

 Distribution of seeing for i-band observations of field B1

.. figure:: /_static/Seeing_B2_i.png
 :name: seeing_B2_i

 Distribution of seeing for i-band observations of field B2


Running the Science Pipelines
=============================

Running the LSST Science Pipelines on observations of crowded fields follows the same steps as for fields with lower densities, but a few of those steps require modification to work properly.
Here, we divide processing into three distinct stages:

1. **Single Frame Processing**: includes applying flat field and bias corrections, Instrument Signature Removal, and astrometric and photometric calibration.
2. **Coaddition**: includes warping and PSF-matching the individual exposures, as well as the actual coaddition algorithm.
3. **Alert Production**: includes all of Single Frame Processing for the science images, as well as warping the templates, performing image differencing, detecting and measuring sources, and associating sources from different visits to form objects.



Single Frame Processing
-----------------------

The initial stages of Single Frame Processing require no modifications to accomodate crowded fields.
Once processing moves on to the first instance of source detection, however, it becomes important to set the detection threshold to a fixed value rather than the default of a multiple of the standard deviation of the background.
There may be no pixels without a detectable source in the exposures, so the measured background level will be incorrect and the number of sources used for PSF modeling will be unpredictable, and possibly too few.
For this test, we took typical detection thresholds from DECam HiTS observations and found that those eliminated the related processing errors.
Further refinement would likely yield improved results.
All of the modifications needed to run single frame processing on these data can be found in :numref:`processCcd_config`, below.

.. table:: Modified config settings needed for single frame processing
   :name: processCcd_config

   ============================================== ======== ======
   Modified config settings for processCcd.py     value    band 
   ============================================== ======== ======
   charImage.requireCrForPsf                      False    i, g
   charImage.detection.thresholdValue             10000    i    
   charImage.detection.thresholdValue             2500     g    
   charImage.detection.includeThresholdMultiplier 1.0      i, g  
   charImage.detection.thresholdType              "value"  i, g  
   charImage.repair.cosmicray.nCrPixelMax         10000000 i, g  
   charImage.repair.cosmicray.min_DN              10000    i    
   charImage.repair.cosmicray.min_DN              2500     g    
   ============================================== ======== ======

Beyond the source detection thresholds, it was necessary to modify two additional components.
We found that the default algorithm for measuring the PSF, a simple PCA-based model, simply failed when run on most of the visits from these crowded fields.
However, PSFex was able to successfully measure the PSF, and since it was already available in the Science Pipelines we made it the default for all cameras.
Thus, no further modifications are needed for future processing.

The final component that requires modification is the cosmic ray detection and repair algorithm.
As noted above, the assumptions behind the pixel value statistics are incorrect in crowded fields.
We set the detection thresholds to the same values as for source detection (:numref:`processCcd_config`), and while this works in most cases, for just under 1% of the exposures ``processCcd.py`` fails with a fatal error.
In these cases the failure appears to be due to every pixel in the image being identified as a cosmic ray.
This failure suggests that our cosmic ray detection algorithm needs improvement and should be investigated further, but because of the low number of exposures affected we simply increased the number of pixels required to trigger the failure.
This does not solve the problem, but it allows us to continue processing these exposures to make sure that there are no additional problems.

Evaluation of the Point Spread Function (PSF)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The accuracy of the measurement of the Point Spread Function (PSF) is our greatest concern with processing crowded fields, since it is typically not possible to find a sufficient number of isolated stellar sources to measure.
The PSF is used for very little in the current Science Pipelines; our standard Alard&Lupton-style image differencing depends only on the calculated size of the PSF to compare with that of the template, and not on the shape of the PSF.
However, the accuracy of the PSF does impact source measurement and many science use cases.
It is likely that the current implementation of PSFex is sufficient for internal processing of crowded field data, but scientists with strict requirements on the quality of the PSF would be advised to measure the PSF independently in post-processing with a carefully tuned algorithm.

In figures :numref:`psf_B1_2013_g` through :numref:`psf_B2_2015_i` below, we show the PSF for every visit for CCD 42, located near the center of the focal plane.
The color scale is set to highlight features in the wings, while contours at logarithmic intervals capture the shape of the core of the PSF.
Each PSF is normalized to have a sum of 1, and the same color scale and contour levels are used for every image.

.. figure:: /_static/psf_B1_2013_g.png
 :name: psf_B1_2013_g

 PSFs for each of the g-band visits from 2013 in field B1, for a CCD in the center of the focal plane.

.. figure:: /_static/psf_B2_2013_g.png
 :name: psf_B2_2013_g

 PSFs for each of the g-band visits from 2013 in field B2, for a CCD in the center of the focal plane.

.. figure:: /_static/psf_B1_2013_i.png
 :name: psf_B1_2013_i

 PSFs for each of the i-band visits from 2013 in field B1, for a CCD in the center of the focal plane.

.. figure:: /_static/psf_B2_2013_i.png
 :name: psf_B2_2013_i

 PSFs for each of the i-band visits from 2013 in field B2, for a CCD in the center of the focal plane.

.. figure:: /_static/psf_B1_2015_g.png
 :name: psf_B1_2015_g

 PSFs for each of the g-band visits from 2015 in field B1, for a CCD in the center of the focal plane.

.. figure:: /_static/psf_B2_2015_g.png
 :name: psf_B2_2015_g

 PSFs for each of the g-band visits from 2015 in field B2, for a CCD in the center of the focal plane.

.. figure:: /_static/psf_B1_2015_i.png
 :name: psf_B1_2015_i

 PSFs for each of the i-band visits from 2015 in field B1, for a CCD in the center of the focal plane.

.. figure:: /_static/psf_B2_2015_i.png
 :name: psf_B2_2015_i

 PSFs for each of the i-band visits from 2015 in field B2, for a CCD in the center of the focal plane.


Density of measured sources on a single ccd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. figure:: /_static/Source_density_B1_g_ccd42.png
 :name: source_density_B1_g

 Density of detected sources across all visits for field B1 in g-band, for ccd 42.
 Compare to :numref:`dia_source_density_B1_g` for the number of sources in the difference images.

.. figure:: /_static/Source_density_B2_g_ccd42.png
 :name: source_density_B2_g

 Density of detected sources across all visits for field B2 in g-band, for ccd 42.
 Compare to :numref:`dia_source_density_B2_g` for the number of sources in the difference images.

.. figure:: /_static/Source_density_B1_i_ccd42.png
 :name: source_density_B1_i

 Density of detected sources across all visits for field B1 in i-band, for ccd 42.
 Compare to :numref:`dia_source_density_B1_i` for the number of sources in the difference images.

.. figure:: /_static/Source_density_B2_i_ccd42.png
 :name: source_density_B2_i

 Density of detected sources across all visits for field B2 in i-band, for ccd 42.
 Compare to :numref:`dia_source_density_B2_i` for the number of sources in the difference images.


Warping and coaddition
----------------------

.. figure:: /_static/Mosaic_of_g_nImages.png
 :name: Mosaic_of_g_nImages_2013

 Overview mosaic of the number of g-band images coadded for both fields from 2013.

.. figure:: /_static/Mosaic_of_g_coadds.png
 :name: Mosaic_of_g_coadds_2013

 Overview mosaic of the g-band coadded deep images for both fields from 2013.

.. figure:: /_static/Mosaic_of_i_nImages.png
 :name: Mosaic_of_i_nImages_2013

 Overview mosaic of the number of i-band images coadded for both fields from 2013.

.. figure:: /_static/Mosaic_of_i_coadds.png
 :name: Mosaic_of_i_coadds_2013

 Overview mosaic of the i-band coadded deep images for both fields from 2013.

.. figure:: /_static/Mosaic_of_g_nImages_2015.png
 :name: Mosaic_of_g_nIamges_2015

 Overview mosaic of the number of g-band images coadded for both fields from 2015.

.. figure:: /_static/Mosaic_of_g_coadds_2015.png
 :name: Mosaic_of_g_coadds_2015

 Overview mosaic of the g-band coadded deep images for both fields from 2015.

.. figure:: /_static/Mosaic_of_i_nImages_2015.png
 :name: Mosaic_of_i_nImages_2015

 Overview mosaic of the number of i-band images coadded for both fields from 2015.

.. figure:: /_static/Mosaic_of_i_coadds_2015.png
 :name: Mosaic_of_i_coadds_2015

 Overview mosaic of the i-band coadded deep images for both fields from 2015.


Image differencing and ``ap_pipe``
----------------------------------

Density of DIA sources on a single ccd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: /_static/DiaSource_density_B1_g_ccd42.png
 :name: dia_source_density_B1_g

 Density of detected DIA sources across all visits for field B1 in g-band, for ccd 42.
 Compare to :numref:`source_density_B1_g` for the number of sources in the original images.

.. figure:: /_static/DiaSource_density_B2_g_ccd42.png
 :name: dia_source_density_B2_g

 Density of detected DIA sources across all visits for field B2 in g-band, for ccd 42.
 Compare to :numref:`source_density_B2_g` for the number of sources in the original images.

.. figure:: /_static/DiaSource_density_B1_i_ccd42.png
 :name: dia_source_density_B1_i

 Density of detected DIA sources across all visits for field B1 in i-band, for ccd 42.
 Compare to :numref:`source_density_B1_i` for the number of sources in the original images.

.. figure:: /_static/DiaSource_density_B2_i_ccd42.png
 :name: dia_source_density_B2_i

 Density of detected DIA sources across all visits for field B2 in i-band, for ccd 42.
 Compare to :numref:`source_density_B2_i` for the number of sources in the original images.

Future work
===========

fake analysis under Gen 3 for completeness

.. Add content here.
.. Do not include the document title (it's automatically added from metadata.yaml).

.. .. rubric:: References

.. Make in-text citations with: :cite:`bibkey`.

.. .. bibliography:: local.bib lsstbib/books.bib lsstbib/lsst.bib lsstbib/lsst-dm.bib lsstbib/refs.bib lsstbib/refs_ads.bib
..    :style: lsst_aa

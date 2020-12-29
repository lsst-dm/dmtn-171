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

:tocdepth: 1

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
must meet requirements even in crowded fields.
The status of the processing also will inform ongoing cadence planning for the overall survey.

The scope of this technote does not include obtaining photometry for static sources in direct images (except insofar as it is required to conduct image differencing), nor comparisons to dedicated crowded field processing codes.
`DMTN-077 <https://dmtn-077.lsst.io>`_ addressess these issues.

Overview of the data
====================

To test the LSST Science Pipelines on crowded fields, we downloaded public data from the DECam survey of the galactic bulge by `Saha et. al <https://arxiv.org/pdf/1902.05637.pdf>`_.
The full survey consists of six fields observed in the six ``ugrizy`` bands, though for this investigation we limited the analysis to g- and i-bands for the two fields closest to the galactic center (B1 and B2).
These data are available on ``lsst-devl`` at ``/datasets/decam``, with the processed data available at ``/project/sullivan/saha2``.
The 

.. _field-coordinates:
 
======  ========  ========
Field   RA        Dec
======  ========  ========
B1      270.8917  -30.0339
B2      272.3500  -31.4350
======  ========  ========

====== ====== ====== ======
Field  band   2013   2015
====== ====== ====== ======
B1       g    30     44
B2       g    31     44
B1       i    53     44
B2       i    49     44
====== ====== ====== ======


Running the Science Pipelines
=============================

Single Frame Processing
-----------------------

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


Future work
===========

fake analysis under Gen 3 for completeness

.. Add content here.
.. Do not include the document title (it's automatically added from metadata.yaml).

.. .. rubric:: References

.. Make in-text citations with: :cite:`bibkey`.

.. .. bibliography:: local.bib lsstbib/books.bib lsstbib/lsst.bib lsstbib/lsst-dm.bib lsstbib/refs.bib lsstbib/refs_ads.bib
..    :style: lsst_aa

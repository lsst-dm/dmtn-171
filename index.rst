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
DMTN-077 addressess these issues.

Future work
===========

fake analysis under Gen 3 for completeness

.. Add content here.
.. Do not include the document title (it's automatically added from metadata.yaml).

.. .. rubric:: References

.. Make in-text citations with: :cite:`bibkey`.

.. .. bibliography:: local.bib lsstbib/books.bib lsstbib/lsst.bib lsstbib/lsst-dm.bib lsstbib/refs.bib lsstbib/refs_ads.bib
..    :style: lsst_aa

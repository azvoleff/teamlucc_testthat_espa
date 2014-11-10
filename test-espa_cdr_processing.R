file_base <- "LE70040682007234ASN00"
file_datestring <- "004-068_2007-234_LE7"

################################################################################
# First test file extraction
################################################################################

context("espa_extract")

################################################################################
# Check ENVI extraction

# First need to clear old files out of that folder
envi_dir <- "ENVI_format"
envi_ls_dir <- file.path(envi_dir, file_datestring)
unlink(envi_ls_dir, recursive=TRUE)
Sys.sleep(.5) # Sleep to give time for full dir removal
test_that("envi_dir started out empty", {
    expect_false(file.exists(envi_ls_dir))
})
# Now extract and test that it worked
suppressMessages(espa_extract(envi_dir, envi_dir))
test_that("envi format file extracted properly", {
    expect_true(file_test('-d', envi_ls_dir))
    expect_true(file_test('-f', file.path(envi_ls_dir, paste0(file_base, ".xml"))))
    expect_true(file_test('-f', file.path(envi_ls_dir, paste0(file_base, "_sr_band1.img"))))
})


################################################################################
# Check HDF-EOS2 extraction

# First need to clear old files out of that folder
hdf_dir <- "HDF-EOS2_format"
hdf_ls_dir <- file.path(hdf_dir, file_datestring)
unlink(hdf_ls_dir, recursive=TRUE)
Sys.sleep(.5) # Sleep to give time for full dir removal
test_that("hdf_dir started out empty", {
    expect_false(file.exists(hdf_ls_dir))
})
# Now extract and test that it worked
suppressMessages(espa_extract(hdf_dir, hdf_dir))
test_that("hdf format file extracted properly", {
    expect_true(file_test('-d', hdf_ls_dir))
    expect_true(file_test('-f', file.path(hdf_ls_dir, paste0(file_base, ".xml"))))
    expect_true(file_test('-f', file.path(hdf_ls_dir, paste0(file_base, "_sr_band1_hdf.img"))))
    expect_true(file_test('-f', file.path(hdf_ls_dir, paste0(file_base, ".hdf"))))
})

################################################################################
# Check TIFF extraction

# First need to clear old files out of that folder
tiff_dir <- "TIFF_format"
tiff_ls_dir <- file.path(tiff_dir, file_datestring)
unlink(tiff_ls_dir, recursive=TRUE)
Sys.sleep(.5) # Sleep to give time for full dir removal
test_that("tiff_dir started out empty", {
    expect_false(file.exists(tiff_ls_dir))
})
# Now extract and test that it worked
suppressMessages(espa_extract(tiff_dir, tiff_dir))
test_that("tiff format file extracted properly", {
    expect_true(file_test('-d', tiff_ls_dir))
    expect_true(file_test('-f', file.path(tiff_ls_dir, paste0(file_base, ".xml"))))
    expect_true(file_test('-f', file.path(tiff_ls_dir, paste0(file_base, "_sr_band1.tif"))))
})

################################################################################
# Check old format HDF (pre-August 2013) extraction

# First need to clear old files out of that folder
hdfold_dir <- "HDF_old_format"
hdfold_ls_dir <- file.path(hdfold_dir, file_datestring)
unlink(hdfold_ls_dir, recursive=TRUE)
Sys.sleep(.5) # Sleep to give time for full dir removal
test_that("hdfold_dir started out empty", {
    expect_false(file.exists(hdfold_ls_dir))
})
# Now extract and test that it worked
suppressMessages(espa_extract(hdfold_dir, hdfold_dir))
test_that("hdfold format file extracted properly", {
    expect_true(file_test('-d', hdfold_ls_dir))
    expect_true(file_test('-f', file.path(hdfold_ls_dir, "lndsr.LE70040682007234ASN00.hdf")))
    expect_true(file_test('-f', file.path(hdfold_ls_dir, "lndsr.LE70040682007234ASN00.hdf.hdr")))
    expect_true(file_test('-f', file.path(hdfold_ls_dir, "lndsr.LE70040682007234ASN00.txt")))
})

################################################################################
# Now test file format detection
################################################################################

context("file format detection")

test_that("file format detection works properly", {
    expect_equal(detect_ls_files(envi_ls_dir), 
                 list(file_bases=paste0("ENVI_format/", file_datestring, "/", file_base), 
                      file_formats="ESPA_CDR_ENVI"))
    expect_equal(detect_ls_files(hdf_ls_dir),
                 list(file_bases=paste0("HDF-EOS2_format/", file_datestring, "/", file_base), 
                      file_formats="ESPA_CDR_HDF"))
    expect_equal(detect_ls_files(tiff_ls_dir),
                 list(file_bases=paste0("TIFF_format/", file_datestring, "/", file_base), 
                      file_formats="ESPA_CDR_TIFF"))
    expect_equal(detect_ls_files(hdfold_ls_dir),
                 list(file_bases=paste0("HDF_old_format/", file_datestring, "/lndsr.", file_base), 
                      file_formats="ESPA_CDR_OLD"))
    #TODO: expect_equal(detect_ls_files(l1t_ls_dir), "L1T")
})

################################################################################
# Test metadata loading
################################################################################

context("metadata handling")

meta <- list()
meta$aq_date <- strptime("2007-08-22 14:42:23.924851Z", format="%Y-%m-%d %H:%M:%OSZ", tz="UTC")
meta$WRS_Path <- "004"
meta$WRS_Row <- "068"
meta$sunelev <- 50.625332
meta$sunazimuth <- 54.740253
meta$short_name <- "L7ESR"

test_that("file format detection works properly", {
    expect_equal(meta, get_metadata(file.path(hdf_ls_dir, file_base), "ESPA_CDR_HDF"))
    expect_equal(meta, get_metadata(file.path(tiff_ls_dir, file_base), "ESPA_CDR_TIFF"))
    expect_equal(meta, get_metadata(file.path(envi_ls_dir, file_base), "ESPA_CDR_ENVI"))
    expect_equal(meta, get_metadata(file.path(hdfold_ls_dir, paste0("lndsr.", file_base)), "ESPA_CDR_OLD"))
    #TODO: expect_equal(meta, get_metadata(file.path(l1t_ls_dir, "lndsr.LE70040682007234ASN00.txt"), "L1T"))
})

################################################################################
# Test preprocessing with auto_preprocess_landsat. These tests take 5-6 minutes 
# each.
################################################################################
context("auto_preprocess_landsat")

prefix <- 'test'

# image_dirs <- envi_ls_dir
# prefix <- "TEST"
# tc=FALSE
# dem_path=NULL
# aoi=NULL
# output_path=envi_ls_dir
# mask_type='fmask'
# mask_output=FALSE
# n_cpus=4
# cleartmp=FALSE
# overwrite=FALSE
# of="GTiff"
# ext='tif'
# notify=print
# verbose <- TRUE

tiff_preproc_out <- auto_preprocess_landsat(tiff_ls_dir, prefix=prefix, tc=FALSE, 
                                           output_path=tiff_ls_dir, 
                                           verbose=TRUE)
envi_preproc_out <- auto_preprocess_landsat(envi_ls_dir, prefix=prefix, tc=FALSE, 
                                           output_path=envi_ls_dir, 
                                           verbose=TRUE)
hdf_preproc_out <- auto_preprocess_landsat(hdf_ls_dir, prefix=prefix, tc=FALSE, 
                                           output_path=hdf_ls_dir, 
                                           verbose=TRUE)
hdfold_preproc_out <- auto_preprocess_landsat(hdfold_ls_dir, prefix=prefix, 
                                              tc=FALSE,  
                                              output_path=hdfold_ls_dir, 
                                              verbose=TRUE)

envi_preproc_bands <- stack(envi_preproc_out$bands_file)
envi_preproc_masks <- stack(envi_preproc_out$masks_file)
# Test that a few random pixels have the expected values
test_that("preprocessing works properly", {
    expect_equivalent(getValuesBlock(envi_preproc_bands, 3426, 1, 3281, 1),
                      matrix(c(263, 363, 213, 2926, 1376, 508)))
    expect_equivalent(getValuesBlock(envi_preproc_masks, 3426, 1, 3281, 1),
                      matrix(c(0, 0)))
    expect_equivalent(getValuesBlock(envi_preproc_masks, 1, 1, 1, 1),
                      matrix(c(255, 255)))
})

tiff_preproc_bands <- stack(tiff_preproc_out$bands_file)
envi_preproc_bands <- stack(envi_preproc_out$bands_file)
hdfold_preproc_bands <- stack(hdfold_preproc_out$bands_file)
test_that("preprocessing results matach regardless of input file format", {
    expect_equal(getValues(tiff_preproc_bands), getValues(envi_preproc_bands))
    expect_equal(getValues(tiff_preproc_bands), getValues(hdf_preproc_bands))
    expect_equal(getValues(tiff_preproc_bands), getValues(hdfold_preproc_bands))
})

################################################################################
# Test auto-calc_predictors
################################################################################

aoi <- readOGR(".", "test_aoi")
auto_preprocess_landsat(image_dirs, "VB", tc=FALSE, dem_path=output_path, 
                        output_path=paste0(output_path, '_preproc'),
                        verbose=TRUE, n_cpus=4, aoi=aoi, overwrite=TRUE)

################################################################################
# Cleanup
################################################################################
unlink(envi_ls_dir, recursive=TRUE)
unlink(hdf_ls_dir, recursive=TRUE)
unlink(tiff_ls_dir, recursive=TRUE)
unlink(hdfold_ls_dir, recursive=TRUE)

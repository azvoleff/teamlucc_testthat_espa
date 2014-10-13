context("espa_extract")

################################################################################
# Check ENVI extraction

# First need to clear old files out of that folder
envi_dir <- "ENVI_format"
envi_ls_dir <- file.path(envi_dir, "004-068_2007-234_LE7")
unlink(envi_ls_dir, recursive=TRUE)
Sys.sleep(.5) # Sleep to give time for full dir removal
test_that("envi_dir started out empty", {
    expect_false(file.exists(envi_ls_dir))
})
# Now extract and test that it worked
suppressMessages(espa_extract(envi_dir, envi_dir))
test_that("envi format file extracted properly", {
    expect_true(file_test('-d', envi_ls_dir))
    expect_true(file_test('-f', file.path(envi_ls_dir, "LE70040682007234ASN00.xml")))
    expect_true(file_test('-f', file.path(envi_ls_dir, "LE70040682007234ASN00_toa_band1.img")))
})
unlink(envi_ls_dir, recursive=TRUE)

################################################################################
# Check HDF-EOS2 extraction

# First need to clear old files out of that folder
hdf_dir <- "HDF-EOS2_format"
hdf_ls_dir <- file.path(hdf_dir, "004-068_2007-234_LE7")
unlink(hdf_ls_dir, recursive=TRUE)
Sys.sleep(.5) # Sleep to give time for full dir removal
test_that("hdf_dir started out empty", {
    expect_false(file.exists(hdf_ls_dir))
})
# Now extract and test that it worked
suppressMessages(espa_extract(hdf_dir, hdf_dir))
test_that("hdf format file extracted properly", {
    expect_true(file_test('-d', hdf_ls_dir))
    expect_true(file_test('-f', file.path(hdf_ls_dir, "LE70040682007234ASN00.xml")))
    expect_true(file_test('-f', file.path(hdf_ls_dir, "LE70040682007234ASN00_toa_band1_hdf.img")))
    expect_true(file_test('-f', file.path(hdf_ls_dir, "LE70040682007234ASN00.hdf")))
})
unlink(hdf_ls_dir, recursive=TRUE)

################################################################################
# Check TIFF extraction

# First need to clear old files out of that folder
tiff_dir <- "TIFF_format"
tiff_ls_dir <- file.path(tiff_dir, "004-068_2007-234_LE7")
unlink(tiff_ls_dir, recursive=TRUE)
Sys.sleep(.5) # Sleep to give time for full dir removal
test_that("tiff_dir started out empty", {
    expect_false(file.exists(tiff_ls_dir))
})
# Now extract and test that it worked
suppressMessages(espa_extract(tiff_dir, tiff_dir))
test_that("tiff format file extracted properly", {
    expect_true(file_test('-d', tiff_ls_dir))
    expect_true(file_test('-f', file.path(tiff_ls_dir, "LE70040682007234ASN00.xml")))
    expect_true(file_test('-f', file.path(tiff_ls_dir, "LE70040682007234ASN00_toa_band1.tif")))
})
unlink(tiff_ls_dir, recursive=TRUE)

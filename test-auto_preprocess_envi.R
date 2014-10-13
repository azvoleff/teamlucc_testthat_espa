context("chg_dir")

test_mat1 <- matrix(c(.2, 0, .5), nrow=1)
test_mat2 <- matrix(c(.3, 0, .7), nrow=1)
test_mat2_na <- matrix(c(.3, NA, .7), nrow=1)

test_that("change direction works for valid probabilities", {
    expect_equal(calc_chg_dir(test_mat1, test_mat2), matrix(7))
})

test_that("change direction returns NA when a probability is NA", {
    expect_equivalent(calc_chg_dir(test_mat1, test_mat2_na), matrix(NA))
})

aoi <- readOGR(".", "test_aoi")
auto_preprocess_landsat(image_dirs, "VB", tc=FALSE, dem_path=output_path, 
                        output_path=paste0(output_path, '_preproc'),
                        verbose=TRUE, n_cpus=4, aoi=aoi, overwrite=TRUE)

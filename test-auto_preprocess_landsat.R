context("auto_preprocess_landsat")

aoi <- readOGR(".", "test_aoi")
auto_preprocess_landsat(image_dirs, "VB", tc=FALSE, dem_path=output_path, 
                        output_path=paste0(output_path, '_preproc'),
                        verbose=TRUE, n_cpus=4, aoi=aoi, overwrite=TRUE)

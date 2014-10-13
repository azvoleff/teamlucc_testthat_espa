context("espa_extract")

envi_tar_gz <- dir('envi_format', 
                   pattern='LE70040682007234-[A-Z]{2}[0-9]{14}.tar.gz', 
                   full.path=TRUE)
espa_extract('envi_format', 'envi_format')


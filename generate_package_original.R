##########################################################################################
# DIRECTORIES
##########################################################################################
# R CMD check worldbank
# R CMD Rd2pdf worldbank
# R CMD build worldbank --resave-data
library(devtools)
library(roxygen2)
rm(list=ls(all=TRUE))
directory<-paste0(gsub("generate_package.R","",rstudioapi::getActiveDocumentContext()$path))
setwd(directory)
getwd()
# usethis::create_package("worldbank")
# usethis::use_data(mfi,mfi_cor,mfi_population,overwrite=TRUE)
# usethis::use_data_raw(name='data/mfi.rda')
# usethis::use_data_raw(name='data/mfi_cor.rda')
# usethis::use_data_raw(name='data/mfi_population.rda')
devtools::document()
devtools::install()
library(worldbank)
worldbank()

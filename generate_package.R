##########################################################################################
# DIRECTORIES
##########################################################################################
# R CMD check covid
# R CMD Rd2pdf covid
# R CMD build covid --resave-data
library(devtools)
library(roxygen2)
setwd(paste0(gsub("generate_package.R","",rstudioapi::getActiveDocumentContext()$path)))
usethis::create_package("worldbank")
usethis::use_data_raw(name='data/mfi.rda')
file.create("R/data.R")
document()
install()
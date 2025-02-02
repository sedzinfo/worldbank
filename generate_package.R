##########################################################################################
# DIRECTORIES
##########################################################################################
# R CMD check worldbank
# R CMD Rd2pdf worldbank
# R CMD build worldbank --resave-data
library(devtools)
library(roxygen2)
setwd(paste0(gsub("generate_package.R","",rstudioapi::getActiveDocumentContext()$path)))
# usethis::create_package("worldbank")
# usethis::use_data_raw(name='data/mfi.rda')
# file.create("R/data.R")
rm(list=c("worldbank"))
document()
install()
worldbank()

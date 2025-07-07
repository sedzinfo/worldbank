##########################################################################################
# DIRECTORIES
##########################################################################################
# R CMD check worldbank
# R CMD Rd2pdf worldbank
# R CMD build worldbank --resave-data
library(devtools)
library(roxygen2)
directory<-paste0(gsub("generate_package.R","",rstudioapi::getActiveDocumentContext()$path))
# setwd(paste0(gsub("worldbank/","",directory)))
setwd(directory)
getwd()
# usethis::create_package("worldbank")
usethis::use_data(mfi,mfi_cor,mfi_population,overwrite=TRUE)
file.create("R/data.R")
rm(list=c("worldbank"))
document()
install()
library(worldbank)
worldbank()

##########################################################################################
# DIRECTORIES
##########################################################################################
# R CMD check worldbank
# R CMD Rd2pdf worldbank
# R CMD build worldbank --resave-data
library(devtools)
library(roxygen2)
rm(list = ls())
graphics.off()
cat("\014")
##########################################################################################
# FUNCTIONS PACKAGE
##########################################################################################
directory <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(directory)
# usethis::create_package("worldbank")
# usethis::use_data(mfi,mfi_cor,mfi_population,overwrite=TRUE)
# usethis::use_data_raw(name='data/mfi.rda')
# usethis::use_data_raw(name='data/mfi_cor.rda')
# usethis::use_data_raw(name='data/mfi_population.rda')
document()
if ("worldbank" %in% rownames(installed.packages())) remove.packages("worldbank")
install()
library(worldbank)

pkgdown::build_site(getwd())
system("R CMD Rd2pdf . --force --no-preview --output=worldbank.pdf")
if (.Platform$OS.type == "windows") shell.exec("worldbank.pdf") else system("evince worldbank.pdf")
system("R CMD build . --resave-data")

worldbank() # starts the app: the console stays busy until you close it

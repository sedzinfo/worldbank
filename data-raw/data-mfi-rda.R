## code to prepare `data/mfi.rda` dataset goes here

directory<-paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
directory<-gsub("/data-raw","",directory)
load(file=paste0(directory,"data/mfi.rda"))
load(file=paste0(directory,"data/country_code.rda"))
load(file=paste0(directory,"data/mfi_population.rda"))

usethis::use_data(mfi,country_code,mfi_population,overwrite=TRUE)


## code to prepare `data/mfi.rda` dataset goes here

directory<-paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
directory<-gsub("/data-raw","",directory)
load(file=paste0(directory,"data/mfi.rda"))

usethis::use_data(mfi, overwrite = TRUE)

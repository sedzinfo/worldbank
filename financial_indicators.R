##########################################################################################
# LOAD
##########################################################################################
rm(list=ls())
cat("\014")
graphics.off()
directory<-paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
# download.file("https://databank.worldbank.org/data/download/WDI_CSV.zip",
#               paste0(directory,"data/WDI_CSV.zip"),
#               method="libcurl",quiet=FALSE,mode="w",
#               cacheOK=FALSE,extra=getOption("download.file.extra"),headers=NULL)
# unzip(zipfile=paste0(directory,"data/WDI_CSV.zip"),
#       exdir=paste0(directory,"data/"),
#       files=c("WDICSV.csv"),list=FALSE,overwrite=TRUE,junkpaths=FALSE,
#       unzip="internal",setTimes=FALSE)
df_wdi<-read.csv(paste0(directory,"data_indicators/WDICSV.csv"),
                 stringsAsFactors=FALSE,
                 check.names=FALSE,
                 na.strings="")
country_code<-read.csv(paste0(directory,"data_indicators/WDICountry.csv"),
                       stringsAsFactors=FALSE,
                       check.names=FALSE,
                       na.strings="")
##########################################################################################
# BARPLOTS
##########################################################################################
df_wdi$`Indicator Code`<-NULL
df_wdi<-df_wdi[!is.nan(as.numeric(rowMeans(df_wdi[,grep("^\\d{4}$",names(df_wdi))],na.rm=TRUE))),]
mdf<-reshape::melt(df_wdi,
                   id.vars=c("Country Name","Country Code","Indicator Name"),
                   variable_name="Year",
                   na.rm=TRUE)
mfi<-merge(country_code[,c("Country Code","Region")],
           mdf,
           by="Country Code",
           all=TRUE)
mfi<-mfi[complete.cases(mfi),]
mfi<-mfi[order(mfi$Year),]
row.names(mfi)<-NULL
##########################################################################################
# CORRELATION
##########################################################################################
mfi_cor<-reshape(mfi[,c("Country Name","Region","Indicator Name","Year","value")],
                 timevar="Indicator Name",
                 idvar=c("Country Name","Region","Year"),
                 direction="wide")
names(mfi_cor)<-gsub("value.","",names(mfi_cor),fixed=TRUE)
row.names(mfi_cor)<-NULL
##########################################################################################
# PYRAMID
##########################################################################################
mfi_population<-mfi[grep("Population ages",mfi$`Indicator Name`),]
mfi_population$sex<-mfi_population$unit<-mfi_population$age<-NA
mfi_population[grep(" female",mfi_population$`Indicator Name`),"sex"]<-"Female"
mfi_population[grep(" male",mfi_population$`Indicator Name`),"sex"]<-"Male"
mfi_population[grep(" total",mfi_population$`Indicator Name`),"sex"]<-"Total"
mfi_population[grep(" total",mfi_population$`Indicator Name`),"unit"]<-"Frequency"
mfi_population[grep(" female",mfi_population$`Indicator Name`),"unit"]<-"Frequency"
mfi_population[grep(" male",mfi_population$`Indicator Name`),"unit"]<-"Frequency"
mfi_population[grep(" of total population",mfi_population$`Indicator Name`),"unit"]<-"Percent"
mfi_population[grep(" of female population",mfi_population$`Indicator Name`),"unit"]<-"Percent"
mfi_population[grep(" of male population",mfi_population$`Indicator Name`),"unit"]<-"Percent"
mfi_population[grep(" 00-04",mfi_population$`Indicator Name`),"age"]<-"00-04"
mfi_population[grep(" 05-09",mfi_population$`Indicator Name`),"age"]<-"05-09"
mfi_population[grep(" 10-14",mfi_population$`Indicator Name`),"age"]<-"10-14"
mfi_population[grep(" 15-19",mfi_population$`Indicator Name`),"age"]<-"15-19"
mfi_population[grep(" 20-24",mfi_population$`Indicator Name`),"age"]<-"20-24"
mfi_population[grep(" 25-29",mfi_population$`Indicator Name`),"age"]<-"25-29"
mfi_population[grep(" 30-34",mfi_population$`Indicator Name`),"age"]<-"30-34"
mfi_population[grep(" 35-39",mfi_population$`Indicator Name`),"age"]<-"35-39"
mfi_population[grep(" 40-44",mfi_population$`Indicator Name`),"age"]<-"40-44"
mfi_population[grep(" 45-49",mfi_population$`Indicator Name`),"age"]<-"45-49"
mfi_population[grep(" 50-54",mfi_population$`Indicator Name`),"age"]<-"50-54"
mfi_population[grep(" 60-64",mfi_population$`Indicator Name`),"age"]<-"60-64"
mfi_population[grep(" 65-69",mfi_population$`Indicator Name`),"age"]<-"65-69"
mfi_population[grep(" 70-74",mfi_population$`Indicator Name`),"age"]<-"70-74"
mfi_population[grep(" 75-79",mfi_population$`Indicator Name`),"age"]<-"75-79"
mfi_population[grep(" 80 and above",mfi_population$`Indicator Name`),"age"]<-"80+"
mfi_population[grep(" 0-14",mfi_population$`Indicator Name`),"age"]<-NA
mfi_population[grep(" 15-64",mfi_population$`Indicator Name`),"age"]<-NA
mfi_population[grep(" 65 and above",mfi_population$`Indicator Name`),"age"]<-NA
mfi_population$age<-factor(mfi_population$age,
                           levels=c("00-04","05-09","10-14",
                                    "15-19","20-24","25-29",
                                    "30-34","35-39","40-44",
                                    "45-49","50-54","60-64",
                                    "65-69","70-74","75-79",
                                    "80+"))
mfi_population<-mfi_population[complete.cases(mfi_population),]
mfi_population$`Country Code`<-mfi_population$Region<-NULL
mfi_population$`2-alpha code`<-mfi_population$`Indicator Code`<-NULL
row.names(mfi_population)<-NULL
##########################################################################################
# SAVE
##########################################################################################
mfi$Region<-NULL
# mfi<-mfi[as.numeric(as.character(mfi$Year))>=1990,]
mfi$Year<-droplevels(mfi$Year)
row.names(mfi)<-NULL

save(mfi,mfi_cor,mfi_population,file=paste0(directory,"data/mfi.rda"))
save(mfi_cor,file=paste0(directory,"data/mfi_cor.rda"))
save(mfi_population,file=paste0(directory,"data/mfi_population.rda"))

load(file=paste0(directory,"data/mfi.rda"))
load(file=paste0(directory,"data/mfi_cor.rda"))
load(file=paste0(directory,"data/mfi_population.rda"))

# workingfunctions::cdf(mfi)
# workingfunctions::cdf(mfi_cor)
# workingfunctions::cdf(mfi_population)

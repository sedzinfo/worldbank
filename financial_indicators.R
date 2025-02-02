##########################################################################################
# LOAD
##########################################################################################
rm(list=ls())
cat("\014")
graphics.off()
directory<-gsub("financial_indicators.R","",rstudioapi::getSourceEditorContext()$path)
download.file("https://databank.worldbank.org/data/download/WDI_CSV.zip",
              paste0(directory,"data/WDI_CSV.zip"),
              method="libcurl",quiet=FALSE,mode="w",cacheOK=FALSE,extra=getOption("download.file.extra"),headers=NULL)
unzip(zipfile=paste0(directory,"data/WDI_CSV.zip"),
      exdir=paste0(directory,"data/"),
      files=c("WDIData.csv"),list=FALSE,overwrite=TRUE,junkpaths=FALSE,
      unzip="internal",setTimes=FALSE)
df<-read.csv(paste0(directory,"data/WDICSV.csv"),stringsAsFactors=FALSE)
country_code<-read.csv(paste0(directory,"data/countrycode.csv"),stringsAsFactors=FALSE)
##########################################################################################
# BARPLOTS
##########################################################################################
df$Country.Code<-df$Indicator.Code<-df$X<-NULL
df[df$Country.Name %in% "Brunei Darussalam",]$Country.Name<-"Brunei"
df[df$Country.Name %in% "Congo, Dem. Rep.",]$Country.Name<-"Congo, Democratic Republic of the"
df[df$Country.Name %in% "Congo, Rep.",]$Country.Name<-"Congo, Republic of the"
df[df$Country.Name %in% "Egypt, Arab Rep.",]$Country.Name<-"Egypt"
df[df$Country.Name %in% "Hong Kong SAR, China",]$Country.Name<-"Hong Kong"
df[df$Country.Name %in% "Iran, Islamic Rep.",]$Country.Name<-"Iran"
# df[df$Country.Name %in% "Korea, Dem. People’s Rep.",]$Country.Name<-"Korea, North"
df[df$Country.Name %in% "Korea, Rep.",]$Country.Name<-"Korea, South"
df[df$Country.Name %in% "Kyrgyz Republic",]$Country.Name<-"Kyrgyzstan"
df[df$Country.Name %in% "Lao PDR",]$Country.Name<-"Laos"
df[df$Country.Name %in% "Macao SAR, China",]$Country.Name<-"Macau"
df[df$Country.Name %in% "North Macedonia",]$Country.Name<-"Macedonia"
df[df$Country.Name %in% "Micronesia, Fed. Sts.",]$Country.Name<-"Micronesia, Federated States of"
df[df$Country.Name %in% "Russian Federation",]$Country.Name<-"Russia"
df[df$Country.Name %in% "Sint Maarten (Dutch part)",]$Country.Name<-"Sint Maarten"
df[df$Country.Name %in% "Slovak Republic",]$Country.Name<-"Slovakia"
df[df$Country.Name %in% "Syrian Arab Republic",]$Country.Name<-"Syria"
df[df$Country.Name %in% "Venezuela, RB",]$Country.Name<-"Venezuela"
df[df$Country.Name %in% "Virgin Islands (U.S.)",]$Country.Name<-"Virgin Islands"
df[df$Country.Name %in% "West Bank and Gaza",]$Country.Name<-"West Bank"
df[df$Country.Name %in% "Yemen, Rep.",]$Country.Name<-"Yemen"
df[df$Country.Name %in% "Turkiye",]$Country.Name<-"Turkey"
df<-df[df$Country.Name %in% country_code$country,]
df<-df[!is.nan(as.numeric(rowMeans(df[,grep("X",names(df))],na.rm=TRUE))),]
mdf<-reshape::melt(df,id.vars=c("Country.Name","Indicator.Name"))
names(mdf)<-c("country","indicator","year","value")
mdf$year<-gsub("X","",as.character(mdf$year))
mdf$year<-factor(mdf$year,levels=sort(unique(mdf$year)))
mfi<-merge(country_code,mdf[!mdf$value %in% NA,],by="country",all=TRUE)
mfi<-mfi[complete.cases(mfi),]
mfi$year<-as.character(mfi$year)
mfi<-mfi[order(mfi$year),]
mfi$year<-factor(mfi$year,levels=sort(unique(mdf$year)))
mfi$code<-factor(mfi$code,levels=sort(unique(mfi$code)))
mfi$country<-factor(mfi$country,levels=sort(unique(mfi$country)))
mfi$continent<-factor(mfi$continent,levels=sort(unique(mfi$continent)))
frequency_observation<-data.frame(table(mfi$indicator,mfi$country))
names(frequency_observation)<-c("Indicator","Country","Frequency")
ft<-frequency_observation[frequency_observation$Frequency>50,]
mfi$ci<-paste(mfi$country,mfi$indicator)
ft$ci<-paste(ft$Country,ft$Indicator)
mfi<-tdf<-mfi[mfi$ci%in%ft$ci,]
res<-data.frame(table(tdf$country,tdf$indicator))
##########################################################################################
# CORRELATION
##########################################################################################
mfi_cor<-reshape(mfi,timevar="indicator",idvar=c("year","country","code","continent"),direction="wide")
names(mfi_cor)<-gsub("value.","",names(mfi_cor),fixed=TRUE)
##########################################################################################
# PYRAMID
##########################################################################################
mfi_population<-mfi[grep("Population ages",mfi$indicator),]
mfi_population$sex<-mfi_population$unit<-mfi_population$age<-NA
mfi_population[grep(" female",mfi_population$indicator),"sex"]<-"Female"
mfi_population[grep(" male",mfi_population$indicator),"sex"]<-"Male"
mfi_population[grep(" total",mfi_population$indicator),"sex"]<-"Total"
mfi_population[grep(" total",mfi_population$indicator),"unit"]<-"Frequency"
mfi_population[grep(" female",mfi_population$indicator),"unit"]<-"Frequency"
mfi_population[grep(" male",mfi_population$indicator),"unit"]<-"Frequency"
mfi_population[grep(" of total population",mfi_population$indicator),"unit"]<-"Percent"
mfi_population[grep(" of female population",mfi_population$indicator),"unit"]<-"Percent"
mfi_population[grep(" of male population",mfi_population$indicator),"unit"]<-"Percent"
mfi_population[grep(" 00-04",mfi_population$indicator),"age"]<-"00-04"
mfi_population[grep(" 05-09",mfi_population$indicator),"age"]<-"05-09"
mfi_population[grep(" 10-14",mfi_population$indicator),"age"]<-"10-14"
mfi_population[grep(" 15-19",mfi_population$indicator),"age"]<-"15-19"
mfi_population[grep(" 20-24",mfi_population$indicator),"age"]<-"20-24"
mfi_population[grep(" 25-29",mfi_population$indicator),"age"]<-"25-29"
mfi_population[grep(" 30-34",mfi_population$indicator),"age"]<-"30-34"
mfi_population[grep(" 35-39",mfi_population$indicator),"age"]<-"35-39"
mfi_population[grep(" 40-44",mfi_population$indicator),"age"]<-"40-44"
mfi_population[grep(" 45-49",mfi_population$indicator),"age"]<-"45-49"
mfi_population[grep(" 50-54",mfi_population$indicator),"age"]<-"50-54"
mfi_population[grep(" 60-64",mfi_population$indicator),"age"]<-"60-64"
mfi_population[grep(" 65-69",mfi_population$indicator),"age"]<-"65-69"
mfi_population[grep(" 70-74",mfi_population$indicator),"age"]<-"70-74"
mfi_population[grep(" 75-79",mfi_population$indicator),"age"]<-"75-79"
mfi_population[grep(" 80 and above",mfi_population$indicator),"age"]<-"80+"
mfi_population[grep(" 0-14",mfi_population$indicator),"age"]<-NA
mfi_population[grep(" 15-64",mfi_population$indicator),"age"]<-NA
mfi_population[grep(" 65 and above",mfi_population$indicator),"age"]<-NA
mfi_population$age<-factor(mfi_population$age,levels=c("00-04","05-09","10-14","15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","60-64","65-69","70-74","75-79","80+"))
mfi_population<-mfi_population[complete.cases(mfi_population),]
mfi_population$code<-mfi_population$continent<-NULL
##########################################################################################
# SAVE
##########################################################################################
save(mfi,mfi_cor,mfi_population,file=paste0(directory,"data/mfi.rda"))
load(file=paste0(directory,"data/mfi.rda"))

workingfunctions::cdf(mfi)
workingfunctions::cdf(mfi_cor)
workingfunctions::cdf(mfi_population)









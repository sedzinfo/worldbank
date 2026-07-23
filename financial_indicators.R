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
df_wdi<-read.csv(paste0(directory,"data/WDICSV.csv"),
                 stringsAsFactors=FALSE,
                 check.names=FALSE,
                 na.strings="")
country_code<-read.csv(paste0(directory,"data/WDICountry.csv"),
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

save(mfi,file=paste0(directory,"data/mfi.rda"),version=3)
save(country_code,file=paste0(directory,"data/country_code.rda"),version=3)
save(mfi_population,file=paste0(directory,"data/mfi_population.rda"),version=3)

# rwf::cdf(mfi)
# rwf::cdf(mfi_cor)
# rwf::cdf(mfi_population)


mfi_greece<-mfi[mfi$`Country Name`%in%"Greece",]

unique(mfi_greece$`Indicator Name`)
##########################################################################################
# SCATTERPLOTS: GREECE FERTILITY vs GDP
##########################################################################################
# note: WDI has no debt data at all for Greece (its debt indicators mainly cover
# developing economies), so only fertility vs GDP per capita is plotted here.
scatter_indicators<-c("Fertility rate, total (births per woman)",
                      "GDP per capita (current US$)")
mfi_greece_scatter<-mfi[mfi$`Country Name`%in%"Greece"&mfi$`Indicator Name`%in%scatter_indicators,]
mfi_greece_scatter<-reshape(mfi_greece_scatter[,c("Country Name","Year","Indicator Name","value")],
                            timevar="Indicator Name",
                            idvar=c("Country Name","Year"),
                            direction="wide")
names(mfi_greece_scatter)<-gsub("value.","",names(mfi_greece_scatter),fixed=TRUE)
names(mfi_greece_scatter)[names(mfi_greece_scatter)=="Fertility rate, total (births per woman)"]<-"Fertility"
names(mfi_greece_scatter)[names(mfi_greece_scatter)=="GDP per capita (current US$)"]<-"GDP"
mfi_greece_scatter$Year<-as.numeric(as.character(mfi_greece_scatter$Year))

greece_fertility_gdp<-mfi_greece_scatter[complete.cases(mfi_greece_scatter[,c("Fertility","GDP")]),]

plot_fertility_gdp<-plotly::plot_ly(greece_fertility_gdp,
                                    x=~GDP,
                                    y=~Fertility,
                                    color=~Year,
                                    text=~paste0("\nYear=",Year,
                                                 "\nGDP per capita=",round(GDP,0),
                                                 "\nFertility=",round(Fertility,2)),
                                    type="scatter",
                                    mode="markers")
plot_fertility_gdp<-plotly::layout(plot_fertility_gdp,
                                   title=list(text="Greece: Fertility Rate vs<br>GDP per Capita (current US$)",
                                             font=list(size=26)),
                                   font=list(size=18),
                                   margin=list(t=120),
                                   xaxis=list(title="GDP per capita (current US$)"),
                                   yaxis=list(title="Fertility rate, total (births per woman)"))
plot_fertility_gdp
##########################################################################################
# BARPLOTS: GREECE FERTILITY AND GDP BY YEAR (dual axis, grouped)
##########################################################################################
bar_fertility_gdp<-plotly::plot_ly(greece_fertility_gdp)
bar_fertility_gdp<-plotly::add_trace(bar_fertility_gdp,
                                     x=~Year,
                                     y=~GDP,
                                     type="bar",
                                     name="GDP per capita (current US$)",
                                     yaxis="y",
                                     offsetgroup="GDP",
                                     marker=list(color="#1f77b4"))
bar_fertility_gdp<-plotly::add_trace(bar_fertility_gdp,
                                     x=~Year,
                                     y=~Fertility,
                                     type="bar",
                                     name="Fertility rate, total (births per woman)",
                                     yaxis="y2",
                                     offsetgroup="Fertility",
                                     marker=list(color="#d62728"))
bar_fertility_gdp<-plotly::layout(bar_fertility_gdp,
                                  barmode="group",
                                  title=list(text="Greece: Fertility Rate and GDP per Capita by Year",
                                            font=list(size=26)),
                                  font=list(size=18),
                                  margin=list(t=140,b=150,r=150),
                                  xaxis=list(title="Year",tickangle=-90,tickmode="linear",dtick=1),
                                  yaxis=list(title="GDP per capita (current US$)",side="left",automargin=TRUE),
                                  yaxis2=list(title="Fertility rate, total (births per woman)",
                                              overlaying="y",
                                              side="right",
                                              showgrid=FALSE,
                                              automargin=TRUE),
                                  # legend=list(orientation="h",xanchor="center",x=.5,y=1.2),
                                  annotations=list(list(text="Source: World Bank, World Development Indicators (WDI)",
                                                        showarrow=FALSE,
                                                        xref="paper",yref="paper",
                                                        x=0,y=-.35,
                                                        xanchor="left",yanchor="top",
                                                        font=list(size=10,color="grey10"))))
bar_fertility_gdp

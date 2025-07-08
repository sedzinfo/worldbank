##########################################################################################
# WORLDBANK
##########################################################################################
#' @title World Bank financial indicators
#' @import shiny
#' @import magrittr
#' @importFrom DT renderDataTable dataTableOutput datatable formatStyle
#' @importFrom plotly plotlyOutput renderPlotly plot_ly layout animation_opts add_text
#' @importFrom dplyr mutate group_by case_when
#' @importFrom stats complete.cases
#' @importFrom utils data
#' @keywords worldbank
#' @export
#' @examples
#' # worldbank()
worldbank<-function() {
  data(mfi)
  data(mfi_cor)
  data(mfi_population)
  options(scipen=999)
  font_style<-list(size=15,color="gray25",weight="bold")
  colors=c("#e6194b","#3cb44b","#ffe119","#0082c8","#f58231","#911eb4","#46f0f0","#f032e6","#d2f53c","#fabebe","#008080","#e6beff","#aa6e28","#fffac8","#800000","#aaffc3","#808000","#ffd8b1","#000080","#808080","#ffffff","#000000")
  format_bignum=function(n) {
    dplyr::case_when(n>=1e12~paste(round(n/1e12),"Tn"),
                     n>=1e9~paste(round(n/1e9),"Bn"),
                     n>=1e6~paste(round(n/1e6),"M"),
                     n>=1e3~paste(round(n/1e3),"K"),
                     TRUE~as.character(n))
  }
  shinyApp(ui=tagList(tags$head(
    # includeHTML("google-analytics.html"),
                                tags$script('var dimension = [0, 0];
                                  $(document).on("shiny:connected", function(e) {
                                  dimension[0] = window.innerWidth;
                                  dimension[1] = window.innerHeight;
                                  Shiny.onInputChange("dimension", dimension);
                                  });
                                  $(window).resize(function(e) {
                                  dimension[0] = window.innerWidth;
                                  dimension[1] = window.innerHeight;
                                  Shiny.onInputChange("dimension", dimension);
                                  });')),
                      navbarPage("Data: World Bank",
                                 tags$head(
                                   tags$style(HTML('.navbar-nav > li > a, .navbar-brand {
                            padding-top:4px;
                            padding-bottom:0;
                            height: 25px;
                            }
                           .navbar {min-height:25px;}'))
                                 ),
                                 tabPanel("Country Comparison",
                                          selectizeInput(inputId="multiple_country_comp",
                                                         label="Country",
                                                         choices=sort(unique(as.character(mfi$`Country Name`))),
                                                         selected=c("Greece","Bulgaria"),
                                                         options=list(`actions-box`=TRUE,
                                                                      `live-search`=TRUE,
                                                                      `selected-text-format`="count>10"),
                                                         multiple=TRUE,
                                                         width="100%"),
                                          selectizeInput(inputId="indicator_country_comp",
                                                         label="Indicator",
                                                         choices=sort(unique(mfi$`Indicator Name`)),
                                                         selected=c("Population, total"),
                                                         # options = list(maxOptions = 100, maxItems = 50),
                                                         size=50,
                                                         width="100%"),
                                          plotly::plotlyOutput("plot_country_comp")),
                                 tabPanel("Indicator Comparison",
                                          selectizeInput(inputId="multiple_indicator_comp",
                                                         label="Indicator",
                                                         choices=sort(unique(mfi$`Indicator Name`)),
                                                         selected=c("Population, male","Population, female","Population, total"),
                                                         options=list(`actions-box`=TRUE,
                                                                      `live-search`=TRUE,
                                                                      `selected-text-format`="count>10"),
                                                         multiple=TRUE,
                                                         width="100%"),
                                          selectizeInput(inputId="country_indicator_comp",
                                                         label="Country",
                                                         choices=sort(unique(mfi$`Country Name`)),
                                                         selected=c("Greece"),
                                                         size=50,
                                                         width="100%"),
                                          plotly::plotlyOutput("plot_indicator_comp")),
                                 tabPanel("Pyramid",
                                          selectizeInput("indicator_pyramid_country",
                                                         label="",
                                                         choices=sort(unique(mfi$`Country Name`)),
                                                         selected="Greece",
                                                         width="100%"),
                                          plotly::plotlyOutput("plot_pyramid")),
                                 tabPanel("Barplot",
                                          fluidRow(column(5,selectizeInput("indicator_bar",
                                                                           label="",
                                                                           choices=sort(unique(mfi$`Indicator Name`)),
                                                                           selected="GDP (current US$)",
                                                                           width="100%"))),
                                          plotly::plotlyOutput("plot_bar")),
                                 tabPanel("Scatterplot",
                                          fluidRow(column(5,selectizeInput("indicator_cor1",
                                                                           label="",
                                                                           choices=sort(unique(mfi$`Indicator Name`)),
                                                                           selected="Mortality rate, adult, male (per 1,000 male adults)",
                                                                           width="100%"),style="display:inline-block"),
                                                   column(5,selectizeInput("indicator_cor2","",
                                                                           choices=sort(unique(mfi$`Indicator Name`)),
                                                                           selected="Mortality rate, infant (per 1,000 live births)",
                                                                           width="100%"),style="display:inline-block")),
                                          plotly::plotlyOutput("plot_cor")),
                                 tabPanel("Map",
                                          selectizeInput("indicator_map","",
                                                         choices=sort(unique(mfi$`Indicator Name`)),
                                                         selected="Population, total",
                                                         width="100%"),
                                          plotly::plotlyOutput("plot_map")),
                                 tabPanel("Index",DT::dataTableOutput("index_table")))),

           server=function(input,output) {
             observeEvent(input$multiple_country_comp, {
               temp_choice<-mfi[mfi$`Country Name`%in%input$multiple_country_comp,]
               indicator_country_comp<-input$indicator_country_comp
               updateSelectInput(inputId="indicator_country_comp",
                                 choices=unique(temp_choice[complete.cases(temp_choice),"Indicator Name"]),
                                 selected=indicator_country_comp)
             })
             observeEvent(input$country_indicator_comp, {
               temp_choice<-mfi[mfi$`Country Name`%in%input$country_indicator_comp,]
               multiple_indicator_comp<-input$multiple_indicator_comp
               updateSelectInput(inputId="multiple_indicator_comp",
                                 choices=unique(temp_choice[complete.cases(temp_choice),"Indicator Name"]),
                                 selected=multiple_indicator_comp)
             })
             output$plot_country_comp<-plotly::renderPlotly({
               temp<-mfi[mfi$`Country Name`%in%input$multiple_country_comp&mfi$`Indicator Name`%in%input$indicator_country_comp,]
               temp<-temp[complete.cases(temp),]
               temp$Year<-droplevels(temp$Year)
               plotly::plot_ly(temp,
                               x=~temp$Year,
                               y=~temp$value,
                               text=~paste0("\nCountry=",temp$`Country Name`,
                                            "\nIndicator=",temp$`Indicator Name`,
                                            "\nYear=",temp$Year,
                                            "\nValue=",temp$value),
                               color=~temp$`Country Name`,
                               mode="lines+markers",
                               type="scatter",
                               # colors=colors,
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-200)) %>%
                 plotly::layout(autosize=TRUE,
                                margin=list(l=50,r=50,b=50,t=50,pad=0),
                                legend=list(orientation="h",xanchor="center",x=.5,y=1),
                                title=paste("Indicator:",input$indicator_country_comp),
                                xaxis=list(title="",tickangle=-90),
                                yaxis=list(title=input$indicator_country_comp),
                                font=font_style)
             })
             output$plot_indicator_comp<-plotly::renderPlotly({
               temp<-mfi[mfi$`Country Name` %in% input$country_indicator_comp & mfi$`Indicator Name` %in% input$multiple_indicator_comp,]
               # temp<-mfi[mfi$`Country Name` %in% "Greece" & mfi$`Indicator Name` %in% "Population, total",]
               # input<-list(dimension=c(1000,1000))
               temp<-temp[complete.cases(temp),]
               temp$Year<-droplevels(temp$Year)
               plotly::plot_ly(temp,
                               x=~temp$Year,
                               y=~temp$value,
                               # text=~paste0("\nCountry=",temp$`Country Name`,
                               #              "\nIndicator=",temp$`Indicator Name`,
                               #              "\nYear=",temp$Year,
                               #              "\nValue=",temp$value),
                               color=~temp$`Indicator Name`,
                               mode="lines+markers",
                               type="scatter",
                               # colors=colors,
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-200)) %>%
                 plotly::layout(autosize=TRUE,
                                margin=list(l=50,r=50,b=50,t=50,pad=0),
                                legend=list(orientation="h",xanchor="center",x=.5,y=1),
                                title=paste("Country:",input$country_indicator_comp),
                                xaxis=list(title="",tickangle=-90),
                                # yaxis=list(title=gsub("],","]",toString(paste0("[",input$multiple_indicator_comp,"]")))),
                                yaxis=list(title=""),
                                font=font_style)
             })
             output$plot_pyramid<-plotly::renderPlotly({
               temp<-mfi_population[mfi_population$`Country Name`%in%input$indicator_pyramid_country,]
               # temp<-mfi_population[mfi_population$`Country Name`%in%"Greece",]
               temp<-temp[complete.cases(temp),]
               temp[temp$sex%in%"Male","value"]<-temp[temp$sex%in%"Male","value"]*-1
               temp$value<-round(temp$value,2)
               temp$Year<-droplevels(temp$Year)
               plotly::plot_ly(temp,
                               x=~temp$value,
                               y=~temp$age,
                               color=~temp$sex,
                               type='bar',
                               frame=~temp$Year,
                               orientation='h',
                               hoverinfo='text',
                               text=~temp$value,
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-120)
                               ) %>%
                 plotly::layout(bargap=.1,
                                barmode='overlay',
                                title=paste("Country:",input$indicator_pyramid_country),
                                margin=list(l=50,r=50,b=50,t=50,pad=0),
                                yaxis=list(title="Age Group"),
                                xaxis=list(title=list(text="Population",standoff=3),
                                           tickmode='array',
                                           tickvals=-100:100,
                                           ticktext=paste0(c(100:0,1:100),"%")),
                                font=font_style)%>%
                 plotly::animation_opts(frame=500,transition=1,easing="linear",redraw=FALSE,mode="immediate")
             })
             output$plot_bar<-plotly::renderPlotly({
               temp<-mfi[mfi$`Indicator Name`%in%input$indicator_bar,]
               # temp<-mfi[mfi$`Indicator Name`%in%"Population, total",]
               temp<-temp[complete.cases(temp),]
               temp<-temp[temp$value>0,]
               temp$Year<-droplevels(temp$Year)
               temp<-dplyr::mutate(dplyr::group_by(temp,Year),rank=order(order(value,Year,decreasing=TRUE)))
               if(nrow(temp)>1) {
                 plotly::plot_ly(temp,
                                 x=~temp$value,
                                 y=~temp$`Country Name`,
                                 hovertext=~paste0("\nRank=",temp$rank,"\nCountry=",temp$`Country Name`,"\nValue=",format_bignum(temp$value)),
                                 frame=~Year,
                                 hoverinfo="text",
                                 # color=temp$`Country Name`,
                                 # split=~continent,
                                 # colors=colors,
                                 type="bar",
                                 width=(as.numeric(input$dimension[1])-30),
                                 height=(as.numeric(input$dimension[2])-120)) %>%
                   plotly::layout(title=paste0(unique(temp$`Indicator Name`)),
                                  # margin=list(t=60,b=135,l=0,r=0,pad=0),
                                  margin=list(l=50,r=50,b=50,t=50,pad=0),
                                  xaxis=list(title=""),
                                  yaxis=list(title=""),
                                  font=font_style,
                                  showlegend=FALSE) %>%
                   plotly::add_text(text=paste("Rank:",format_bignum(temp$rank)),textposition="right")%>%
                   plotly::animation_opts(frame=500,transition=1,easing="linear",redraw=FALSE,mode="immediate")
               }
             })
             output$plot_map<-plotly::renderPlotly({
               g<-list(showframe=FALSE,showcoastlines=TRUE,projection=list(type='Mercator'))
               temp<-mfi[mfi$`Indicator Name` %in% input$indicator_map,]
               # temp<-mfi[mfi$`Indicator Name` %in% "Population, total",]
               temp$Region[temp$Region==""]<-NA
               temp<-temp[complete.cases(temp),]
               temp$Year<-droplevels(temp$Year)
               plotly::plot_ly(temp,
                               z=~value,
                               frame=~Year,
                               text=~temp$`Country Name`,
                               locations=~temp$`Country Code`,
                               color=~temp$value,
                               type='choropleth',
                               colorbar=list(tickprefix="",title=""),
                               colors='Blues',
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-120)) %>%
                 plotly::layout(autosize=TRUE,
                                showlegend=TRUE,
                                margin=list(l=50,r=50,b=50,t=50,pad=0),
                                legend=list(orientation="h",xanchor="center",x=.5,y=1),
                                title=paste("Indicator:",input$indicator_map),
                                xaxis=list(title=""),
                                yaxis=list(title=""),
                                geo=g,
                                font=font_style)
             })
             output$plot_cor<-plotly::renderPlotly({
               factorlist<-c("Year","Country Name","Region","Population, total")
               temp<-mfi_cor[,c(input$indicator_cor1,input$indicator_cor2,factorlist)]
               # temp<-mfi_cor[,c("Population, total","Population, total",factorlist)]
               temp<-temp[complete.cases(temp),]
               temp$Region[temp$Region==""]<-NA
               temp<-temp[!is.na(temp$Region),]
               temp$Year<-droplevels(temp$Year)
               plotly::plot_ly(temp,
                               x=temp[,1],
                               y=temp[,2],
                               color=~temp$Region,
                               size=~temp$`Population, total`,
                               frame=~Year,
                               text=~paste("\nContinent=",temp$Region,"\nCountry=",temp$`Country Name`),
                               type="scatter",
                               mode="markers",
                               fill=~'',
                               marker=list(sizemode='diameter'),
                               # colors=colors,
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-120)) %>%
                 plotly::layout(autosize=TRUE,
                                showlegend=TRUE,
                                margin=list(l=50,r=50,b=50,t=50,pad=0),
                                # legend=list(orientation="v",xanchor="center",x=.5,y=1),
                                title="",
                                xaxis=list(title=list(text=unique(input$indicator_cor1),standoff=3)),
                                yaxis=list(title=unique(input$indicator_cor2)),
                                font=font_style)%>%
                 plotly::animation_opts(frame=500,transition=1,easing="linear",redraw=FALSE,mode="immediate")
             })
             output$index_table=DT::renderDataTable({
               data<-data.frame(Indicator=unique(mfi$`Indicator Name`))
               result<-DT::datatable(data,options=list(paging=FALSE))
               DT::formatStyle(result,names(result),0,target='row',lineHeight='80%')
             })
           }
  )
}
##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' World Bank Indicators Dataset
#'
#' A cleaned dataset of key indicators from the World Bank for various countries across years.
#'
#' @format A data frame with one row per country-year-indicator combination:
#' \describe{
#'   \item{Country Code}{3-letter ISO country code (e.g., "ABW" for Aruba)}
#'   \item{Region}{World Bank regional classification (e.g., "Latin America & Caribbean")}
#'   \item{Country Name}{Full country name (e.g., "Aruba")}
#'   \item{Indicator Name}{The name of the World Bank indicator (e.g., "School enrollment, primary, female (% gross)")}
#'   \item{Year}{Observation year (numeric)}
#'   \item{value}{Numeric value for the indicator in that country and year}
#' }
#'
#' @details This dataset supports multiple development indicators (social, economic, demographic),
#' covering multiple years and countries. It is used across various tabs in the World Bank Shiny app
#' for data visualization.
#'
#' @source World Bank Open Data via [worldbank.org](https://data.worldbank.org)
#'
#' @examples
#' head(mfi)
"mfi"
##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' Financial Indicators
#'
#' A dataset containing demographics
#'
#' \itemize{
#'   \item{Country Code}{3-letter ISO country code (e.g., "ABW" for Aruba)}
#'   \item{Region}{World Bank regional classification (e.g., "Latin America & Caribbean")}
#'   \item{Country Name}{Full country name (e.g., "Aruba")}
#'   \item{Year}{Observation year (numeric)}
#' }
#'
#' @docType data
#' @keywords datasets
#' @name mfi_cor
#' @usage data(mfi_cor)
#' @format A data frame
#' @examples
#' head(mfi_cor)
"mfi_cor"
##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' Age-Sex Specific Population Percentages
#'
#' A dataset containing age- and sex-specific population percentages for countries, based on World Bank data.
#' Useful for creating population pyramids and analyzing demographic structures.
#'
#' @format A data frame with one row per country-year-age-sex group:
#' \describe{
#'   \item{Country Name}{Full country name (e.g., "Aruba")}
#'   \item{Indicator Name}{The full indicator name (e.g., "Population ages 65-69, female (% of female population)")}
#'   \item{Year}{Observation year (numeric)}
#'   \item{value}{Percentage of population in the specified age-sex group}
#'   \item{age}{Age group (e.g., "65-69", "70-74")}
#'   \item{unit}{Unit of measurement (always "Percent")}
#'   \item{sex}{Sex of the population group ("Female" or "Male")}
#' }
#'
#' @details This dataset focuses on the percentage distribution of male and female populations across 5-year age groups. It is suitable for demographic visualizations such as population pyramids.
#'
#' @source World Bank Open Data via [worldbank.org](https://data.worldbank.org)
#'
#' @examples
#' head(mfi_population)
"mfi_population"

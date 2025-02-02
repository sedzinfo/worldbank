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
  options(scipen=999)
  font_style<-list(family="sans serif",size=10,color='gray')
  colors=c("#e6194b","#3cb44b","#ffe119","#0082c8","#f58231","#911eb4","#46f0f0","#f032e6","#d2f53c","#fabebe","#008080","#e6beff","#aa6e28","#fffac8","#800000","#aaffc3","#808000","#ffd8b1","#000080","#808080","#ffffff","#000000")
  format_bignum=function(n) {
    dplyr::case_when(n>=1e12~paste(round(n/1e12),"Tn"),
                     n>=1e9~paste(round(n/1e9),"Bn"),
                     n>=1e6~paste(round(n/1e6),"M"),
                     n>=1e3~paste(round(n/1e3),"K"),
                     TRUE~as.character(n))
  }
  shinyApp(ui=tagList(tags$head(tags$script('var dimension = [0, 0];
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
                           .navbar {min-height:25px;}'))),
                                 tabPanel("Country Comparison",
                                          selectizeInput(inputId="country_country_comp",
                                                         label="Country",
                                                         choices=sort(unique(as.character(mfi$country))),
                                                         selected=c("Greece","Turkey","Bulgaria"),
                                                         options=list(`actions-box`=TRUE,
                                                                      `live-search`=TRUE,
                                                                      `selected-text-format`="count>10"),
                                                         multiple=TRUE,
                                                         width="100%"),
                                          selectizeInput(inputId="indicator_country_comp",
                                                         label="Indicator",
                                                         choices=sort(unique(mfi$indicator)),
                                                         selected=c("Population, total"),
                                                         width="100%"),
                                          plotly::plotlyOutput("plot_country_comp")),
                                 tabPanel("Indicator Comparison",
                                          selectizeInput(inputId="indicator_indicator_comp",
                                                         label="Indicator",
                                                         choices=sort(unique(mfi$indicator)),
                                                         selected=c("Population, male","Population, female","Population, total"),
                                                         options=list(`actions-box`=TRUE,
                                                                      `live-search`=TRUE,
                                                                      `selected-text-format`="count>10"),
                                                         multiple=TRUE,
                                                         width="100%"),
                                          selectizeInput(inputId="country_indicator_comp",
                                                         label="Country",
                                                         choices=sort(unique(mfi$country)),
                                                         selected=c("Greece"),
                                                         width="100%"),
                                          plotly::plotlyOutput("plot_indicator_comp")),
                                 tabPanel("Pyramid",
                                          fluidRow(column(5,selectizeInput("indicator_pyramid_country",
                                                                           label="",
                                                                           choices=sort(unique(mfi$country)),
                                                                           selected="Greece",
                                                                           width="100%"))),
                                          plotly::plotlyOutput("plot_pyramid")),
                                 tabPanel("Barplot",
                                          fluidRow(column(5,selectizeInput("indicator_bar",
                                                                           label="",
                                                                           choices=sort(unique(mfi$indicator)),
                                                                           selected="GDP (current US$)",
                                                                           width="100%"))),
                                          plotly::plotlyOutput("plot_bar")),
                                 tabPanel("Scatterplot",
                                          fluidRow(column(5,selectizeInput("indicator_cor1",
                                                                           label="",
                                                                           choices=sort(unique(mfi$indicator)),
                                                                           selected="Mortality rate, adult, male (per 1,000 male adults)",
                                                                           width="100%"),style="display:inline-block"),
                                                   column(5,selectizeInput("indicator_cor2","",
                                                                           choices=sort(unique(mfi$indicator)),
                                                                           selected="Mortality rate, infant (per 1,000 live births)",
                                                                           width="100%"),style="display:inline-block")),
                                          plotly::plotlyOutput("plot_cor")),
                                 tabPanel("Map",
                                          fluidRow(column(5,selectizeInput("indicator_map","",
                                                                           choices=sort(unique(mfi$indicator)),
                                                                           selected="Population, total",
                                                                           width="100%"))),
                                          plotly::plotlyOutput("plot_map")),
                                 tabPanel("Index",DT::dataTableOutput("index_table")))),
           server=function(input,output) {
             observeEvent(input$country_country_comp, {
               temp_choice<-mfi[mfi$country%in%input$country_country_comp,]
               updateSelectInput(inputId="indicator_country_comp",
                                 choices=unique(temp_choice[complete.cases(temp_choice),"indicator"]),
                                 selected=c("Population, total"))
             })
             observeEvent(input$country_indicator_comp, {
               temp_choice<-mfi[mfi$country%in%input$country_indicator_comp,]
               updateSelectInput(inputId="indicator_indicator_comp",
                                 choices=unique(temp_choice[complete.cases(temp_choice),"indicator"]),
                                 selected=c("Population, total"))
               
             })
             output$plot_country_comp<-plotly::renderPlotly({
               temp<-mfi[mfi$country%in%input$country_country_comp&mfi$indicator%in%input$indicator_country_comp,]
               temp<-temp[complete.cases(temp),]
               temp$year<-droplevels(temp$year)
               plotly::plot_ly(temp,
                               x=~temp$year,
                               y=~temp$value,
                               text=~paste0("\nCountry=",temp$country,"\nYear=",temp$year,"\nValue=",temp$value),
                               color=~temp$country,
                               mode="lines+markers",
                               type="scatter",
                               # colors=colors,
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-200)) %>%
                 plotly::layout(autosize=TRUE,
                                margin=list(l=50,r=50,b=50,t=50,pad=0),
                                legend=list(orientation="h",xanchor="center",x=.5,y=1),
                                title=paste0("Countries:",input$country_country_comp,"\t","Indicators:",input$indicator_country_comp),
                                xaxis=list(title=""),
                                yaxis=list(title=input$indicator_country_comp),
                                font=font_style)
             })
             output$plot_indicator_comp<-plotly::renderPlotly({
               temp<-mfi[mfi$country %in% input$country_indicator_comp & mfi$indicator %in% input$indicator_indicator_comp,]
               temp<-temp[complete.cases(temp),]
               temp$year<-droplevels(temp$year)
               plotly::plot_ly(temp,
                               x=~year,
                               y=~value,
                               text=~paste0("\nIndicator=",temp$indicator,"\nYear=",temp$year,"\nValue=",temp$value),
                               color=~indicator,
                               mode="lines+markers",
                               type="scatter",
                               # colors=colors,
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-200)) %>%
                 plotly::layout(autosize=TRUE,
                                margin=list(l=50,r=50,b=50,t=50,pad=0),
                                legend=list(orientation="h",xanchor="center",x=.5,y=1),
                                title=paste("Countries:",input$country_indicator_comp,"\t","Indicators:",input$indicator_indicator_comp),
                                xaxis=list(title=""),
                                yaxis=list(title=""),
                                font=font_style)
             })
             output$plot_pyramid<-plotly::renderPlotly({
               temp<-mfi_population[mfi_population$country%in%input$indicator_pyramid_country,]
               temp<-temp[complete.cases(temp),]
               temp[temp$sex%in%"Male","value"]<-temp[temp$sex%in%"Male","value"]*-1
               temp$value<-round(temp$value,2)
               plotly::plot_ly(temp,
                               x=~value,
                               y=~age,
                               color=~sex,
                               type='bar',
                               frame=~year,
                               orientation='h',
                               hoverinfo='text',
                               text=~value,
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-120)) %>%
                 plotly::layout(bargap=.1,barmode='overlay',
                                title=paste0(unique(temp$country)),
                                yaxis=list(title="Age Group"),
                                xaxis=list(title="Population",
                                           tickmode='array',
                                           tickvals=-100:100,
                                           ticktext=paste0(c(100:0,1:100),"%")),
                                font=font_style)%>%
                 plotly::animation_opts(frame=500,transition=1,easing="linear",redraw=FALSE,mode="immediate")
             })
             output$plot_bar<-plotly::renderPlotly({
               temp<-mfi[mfi$indicator%in%input$indicator_bar,]
               temp<-temp[complete.cases(temp),]
               temp<<-temp[temp$value>0,]
               temp$year<-droplevels(temp$year)
               temp<-dplyr::mutate(dplyr::group_by(temp,year),rank=order(order(value,year,decreasing=TRUE)))
               if(nrow(temp)>1) {
                 plotly::plot_ly(temp,
                                 x=~value,
                                 y=~country,
                                 hovertext=~paste0("\nRank=",temp$rank,"\nCountry=",temp$country,"\nValue=",format_bignum(temp$value)),
                                 frame=~year,
                                 hoverinfo="text",
                                 # color=temp$country,
                                 # split=~continent,
                                 # colors=colors,
                                 type="bar",
                                 width=(as.numeric(input$dimension[1])-30),
                                 height=(as.numeric(input$dimension[2])-120)) %>%
                   plotly::layout(xaxis=list(title=""),
                                  yaxis=list(title=""),
                                  font=font_style,
                                  showlegend=FALSE) %>%
                   plotly::add_text(text=format_bignum(temp$rank),textposition="right")%>%
                   plotly::animation_opts(frame=500,transition=1,easing="linear",redraw=FALSE,mode="immediate")
               }
             })
             output$plot_map<-plotly::renderPlotly({
               g<-list(showframe=FALSE,showcoastlines=TRUE,projection=list(type='Mercator'))
               temp<-mfi[mfi$indicator %in% input$indicator_map,]
               temp<-temp[complete.cases(temp),]
               temp$year<-droplevels(temp$year)
               plotly::plot_ly(temp,
                               z=~value,
                               frame=~year,
                               text=~country,
                               locations=~code,
                               color=~value,
                               type='choropleth',
                               colorbar=list(tickprefix="",title=""),
                               colors='Blues',
                               width=(as.numeric(input$dimension[1])-30),
                               height=(as.numeric(input$dimension[2])-120)) %>%
                 plotly::layout(autosize=TRUE,
                                showlegend=TRUE,
                                margin=list(l=50,r=50,b=50,t=50,pad=0),
                                legend=list(orientation="h",xanchor="center",x=.5,y=1),
                                title=paste0("Indicator:",input$indicator_map),
                                xaxis=list(title=""),
                                yaxis=list(title=""),
                                geo=g,
                                font=font_style)
             })
             output$plot_cor<-plotly::renderPlotly({
               factorlist<-c("year","country","continent","Population, total")
               temp<-mfi_cor[,c(input$indicator_cor1,input$indicator_cor2,factorlist)]
               temp<-temp[complete.cases(temp),]
               temp$year<-droplevels(temp$year)
               plotly::plot_ly(temp,
                               x=temp[,input$indicator_cor1],
                               y=temp[,input$indicator_cor2],
                               color=~continent,
                               size=~`Population, total`,
                               frame=~year,
                               text=~paste("\nContinent=",temp$continent,"\nCountry=",temp$country),
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
                                xaxis=list(title=unique(input$indicator_cor1)),
                                yaxis=list(title=unique(input$indicator_cor2)),
                                font=font_style)%>%
                 plotly::animation_opts(frame=500,transition=1,easing="linear",redraw=FALSE,mode="immediate")
             })
             output$index_table=DT::renderDataTable({
               data<-data.frame(Indicator=unique(mfi$indicator))
               result<-DT::datatable(data,options=list(paging=FALSE))
               DT::formatStyle(result,names(result),0,target='row',lineHeight='80%')
             })
           }
  )
}
##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' Financial Indicators
#'
#' A dataset containing financial indicators
#'
#' \itemize{
#'   \item country. country name
#'   \item code. iso country code
#'   \item continent. continent
#'   \item indicator. name of financial indicator
#'   \item year. year
#'   \item value. value of financial indicator
#'   \item ci. country and financial indicator
#' }
#'
#' @docType data
#' @keywords datasets
#' @name mfi
#' @usage data(mfi)
#' @format A data frame
NULL
##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' Financial Indicators
#'
#' A dataset containing demographics
#'
#' \itemize{
#'   \item country. country name
#'   \item code. iso country code
#'   \item continent. continent
#'   \item year. year
#' }
#'
#' @docType data
#' @keywords datasets
#' @name mfi_cor
#' @usage data(mfi_cor)
#' @format A data frame
NULL
##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' Financial Indicators
#'
#' A dataset containing demographics
#'
#' \itemize{
#'   \item country. country name
#'   \item indicator. name of financial indicator
#'   \item year. year
#'   \item value. value of financial indicator
#'   \item age. age group
#'   \item unit. measurement unit
#'   \item sex. sex
#' }
#'
#' @docType data
#' @keywords datasets
#' @name mfi_population
#' @usage data(mfi_population)
#' @format A data frame
NULL

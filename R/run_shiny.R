##########################################################################################
# WORLDBANK
##########################################################################################
#' @title Launch World Bank Data Shiny App
#'
#' @description
#' Initializes and launches a Shiny application for visualizing World Bank data. The app includes
#' dynamic Plotly charts for comparing countries, indicators, and demographic statistics across time.
#'
#' @details
#' This function:
#' \itemize{
#'   \item Loads required datasets: \code{mfi}, \code{mfi_cor}, and \code{mfi_population}.
#'   \item Sets formatting options for numbers and fonts.
#'   \item Defines a helper function \code{format_bignum} for human-readable large numbers (e.g., K, M, Bn, Tn).
#'   \item Launches the Shiny app using \code{shinyApp(ui = ui, server = server)}.
#' }
#'
#' The Shiny app interface includes:
#' \describe{
#'   \item{Country Comparison}{Compare a selected indicator across countries.}
#'   \item{Indicator Comparison}{Compare multiple indicators for one country.}
#'   \item{Population Pyramid}{Visualize male/female population distribution.}
#'   \item{Barplot}{Rank countries by a selected indicator.}
#'   \item{Scatterplot}{Show relationship between two indicators.}
#'   \item{Map}{Animated choropleth map by year.}
#'   \item{Index}{Tabular view of the dataset.}
#' }
#'
#' @note Ensure that the datasets \code{mfi}, \code{mfi_cor}, and \code{mfi_population} are available in your
#' environment or loaded via a package before calling this function.
#'
#' @return A running Shiny app in the default web browser.
#' @import shiny
#' @import plotly
#' @import dplyr
#' @import htmltools
#' @export
#' @examples
#' # worldbank()
worldbank<-function() {
  options(scipen=999)
  data("mfi")
  font_style<-list(size=20,color="gray25",weight="bold")
  colors=c("#e6194b","#3cb44b","#ffe119","#0082c8","#f58231","#911eb4","#46f0f0",
           "#f032e6","#d2f53c","#fabebe","#008080","#e6beff","#aa6e28","#fffac8",
           "#800000","#aaffc3","#808000","#ffd8b1","#000080","#808080","#ffffff",
           "#000000")
  format_bignum=function(n) {
    dplyr::case_when(n>=1e12~paste(round(n/1e12),"Tn"),
                     n>=1e9~paste(round(n/1e9),"Bn"),
                     n>=1e6~paste(round(n/1e6),"M"),
                     n>=1e3~paste(round(n/1e3),"K"),
                     TRUE~as.character(n))
  }
  ##########################################################################################
  # 
  ##########################################################################################
  ui<-navbarPage(
    # includeHTML("google-analytics.html"),
    navbarPage("Data: World Bank",
               header = tags$head(
                 tags$script(HTML('
      var dimension = [0, 0];
      var resizeTimeout = null;
      $(document).on("shiny:connected", function(e) {
        dimension[0] = window.innerWidth;
        dimension[1] = window.innerHeight;
        Shiny.setInputValue("dimension", dimension);
      });
      $(window).on("resize", function() {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(function() {
          dimension[0] = window.innerWidth;
          dimension[1] = window.innerHeight;
          Shiny.setInputValue("dimension", dimension);
        }, 250);
      });
    '))),
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
                                       choices="Population, total",
                                       selected="Population, total",
                                       # options = list(maxOptions = 100, maxItems = 50),
                                       size=50,
                                       width="100%"),
                        plotly::plotlyOutput("plot_country_comp")),
               tabPanel("Indicator Comparison",
                        selectizeInput(inputId="multiple_indicator_comp",
                                       label="Indicator",
                                       choices=c("Population, female","Population, male"),
                                       selected=c("Population, female","Population, male"),
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
                        selectizeInput(inputId="indicator_pyramid_country",
                                       label="",
                                       choices=sort(unique(mfi$`Country Name`)),
                                       selected="Greece",
                                       width="100%"),
                        plotly::plotlyOutput("plot_pyramid")),
               tabPanel("Barplot",
                        fluidRow(column(5,selectizeInput(inputId="indicator_bar",
                                                         label="",
                                                         choices="GDP (current US$)",
                                                         selected="GDP (current US$)",
                                                         width="100%"))),
                        plotly::plotlyOutput("plot_bar")),
               tabPanel("Scatterplot",
                        fluidRow(column(5,selectizeInput(inputId="indicator_cor1",
                                                         label="",
                                                         choices=NULL,
                                                         selected="Mortality rate, adult, male (per 1,000 male adults)",
                                                         width="100%"),
                                        style="display:inline-block"),
                                 column(5,selectizeInput(inputId="indicator_cor2",
                                                         label="",
                                                         choices=NULL,
                                                         selected="Mortality rate, infant (per 1,000 live births)",
                                                         width="100%"),
                                        style="display:inline-block")),
                        plotly::plotlyOutput("plot_cor")),
               tabPanel("Map",
                        selectizeInput(inputId="indicator_map",
                                       label="",
                                       choices="Population, total",
                                       selected="Population, total",
                                       width="100%"),
                        plotly::plotlyOutput("plot_map")),
               tabPanel("Index",DT::dataTableOutput("index_table"))))
  ##########################################################################################
  # 
  ##########################################################################################
  server<-function(input,output,session) {
    observeEvent(input$multiple_country_comp, {
      temp_choice<-mfi[mfi$`Country Name`%in%input$multiple_country_comp,]
      indicator_country_comp<-input$indicator_country_comp
      updateSelectizeInput(session,
                           inputId="indicator_country_comp",
                           choices=unique(temp_choice[complete.cases(temp_choice),"Indicator Name"]),
                           selected=indicator_country_comp,
                           server=TRUE)
    })
    observeEvent(input$country_indicator_comp, {
      temp_choice<-mfi[mfi$`Country Name`%in%input$country_indicator_comp,]
      multiple_indicator_comp<-input$multiple_indicator_comp
      updateSelectizeInput(session,
                           inputId="multiple_indicator_comp",
                           choices=unique(temp_choice[complete.cases(temp_choice),"Indicator Name"]),
                           selected=multiple_indicator_comp,
                           server=TRUE)
    })
    
    updateSelectizeInput(session,
                         inputId="indicator_cor1",
                         label="",
                         choices=sort(unique(mfi$`Indicator Name`)),
                         selected="Mortality rate, adult, male (per 1,000 male adults)",
                         server=TRUE)
    updateSelectizeInput(session,
                         inputId="indicator_cor2",
                         label="",
                         choices=sort(unique(mfi$`Indicator Name`)),
                         selected="Mortality rate, infant (per 1,000 live births)",
                         server=TRUE)
    updateSelectizeInput(session,
                         inputId="indicator_bar",
                         label="",
                         choices=sort(unique(mfi$`Indicator Name`)),
                         selected="GDP (current US$)",
                         server=TRUE)
    updateSelectizeInput(session,
                         inputId="indicator_map",
                         label="",
                         choices=sort(unique(mfi$`Indicator Name`)),
                         selected="Population, total",
                         server=TRUE)
    
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
                      showlegend=TRUE,
                      # colors=colors,
                      width=(as.numeric(input$dimension[1])-30),
                      height=(as.numeric(input$dimension[2])-200)) %>%
        plotly::layout(autosize=TRUE,
                       margin=list(l=50,r=50,b=250,t=100,pad=0),
                       legend=list(orientation="h",xanchor="center",x=.5,y=1),
                       title=paste("Indicator:",input$indicator_country_comp),
                       xaxis=list(title="Year",tickangle=-90),
                       yaxis=list(title=input$indicator_country_comp),
                       showlegend=TRUE,
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
                      showlegend=TRUE,
                      # colors=colors,
                      width=(as.numeric(input$dimension[1])-30),
                      height=(as.numeric(input$dimension[2])-200)) %>%
        plotly::layout(autosize=TRUE,
                       margin=list(l=50,r=50,b=250,t=100,pad=0),
                       legend=list(orientation="h",xanchor="center",x=.5,y=1),
                       title=paste("Country:",input$country_indicator_comp),
                       xaxis=list(title="Year",tickangle=-90),
                       # yaxis=list(title=gsub("],","]",toString(paste0("[",input$multiple_indicator_comp,"]")))),
                       yaxis=list(title=""),
                       showlegend=TRUE,
                       font=font_style)
    })
    output$plot_pyramid<-plotly::renderPlotly({
      temp<-mfi_population[mfi_population$`Country Name`%in%input$indicator_pyramid_country,]
      # temp<-mfi_population[mfi_population$`Country Name`%in%"Greece",]
      temp<-temp[complete.cases(temp),]
      temp[temp$sex%in%"Male","value"]<-temp[temp$sex%in%"Male","value"]*-1
      temp$value<-round(temp$value,2)
      temp$Year<-droplevels(temp$Year)
      temp$display_value<-NA
      temp[temp$sex %in% "Male", "display_value"]<- temp[temp$sex %in% "Male", "value"] * -1
      temp[temp$sex %in% "Female", "display_value"]<- temp[temp$sex %in% "Female", "value"]
      plotly::plot_ly(temp,
                      x=~temp$value,
                      y=~temp$age,
                      color=~temp$sex,
                      ids=~temp$age,
                      type='bar',
                      frame=~Year,
                      orientation='h',
                      hoverinfo='text',
                      textposition='outside',
                      text=~temp$display_value,
                      width=(as.numeric(input$dimension[1])-30),
                      height=(as.numeric(input$dimension[2])-120)) %>%
        plotly::layout(bargap=.1,
                       barmode='overlay',
                       title=paste("Country:",input$indicator_pyramid_country),
                       margin=list(l=50,r=50,b=250,t=100,pad=0),
                       yaxis=list(title="Age Group"),
                       xaxis=list(title=list(text="Population",standoff=3),
                                  tickmode='array',
                                  tickvals=-100:100,
                                  ticktext=paste0(c(100:0,1:100),"%")),
                       font=font_style)%>%
        plotly::animation_opts(frame=500,easing="linear",redraw=TRUE,mode="immediate")
    })
    output$plot_bar<-plotly::renderPlotly({
      temp<-mfi[mfi$`Indicator Name`%in%input$indicator_bar,]
      # temp<-mfi[mfi$`Indicator Name`%in%"Population, total",]
      temp<-temp[complete.cases(temp),]
      temp<-temp[temp$value>0,]
      temp$Year<-droplevels(temp$Year)
      temp<-dplyr::mutate(dplyr::group_by(temp,Year),
                          rank=order(order(value,Year,decreasing=TRUE)))
      temp_factor<-data.frame(temp[temp$Year%in%max(as.character(temp$Year),na.rm=TRUE),],check.names=FALSE)
      
      temp$`Country Name`<-factor(temp$`Country Name`,
                                  levels=temp_factor[order(temp_factor$value),"Country Name"])
      if(nrow(temp)>1) {
        plotly::plot_ly(temp,
                        x=~temp$value,
                        y=~temp$`Country Name`,
                        hovertext=~paste0("\nRank=",temp$rank,
                                          "\nCountry=",temp$`Country Name`,
                                          "\nValue=",format_bignum(temp$value)),
                        frame=~Year,
                        ids=~temp$`Country Name`,
                        hoverinfo="text",
                        # color=temp$`Country Name`,
                        # split=~continent,
                        # colors=colors,
                        type="bar",
                        width=(as.numeric(input$dimension[1])-30),
                        height=(as.numeric(input$dimension[2])-120)) %>%
          plotly::layout(title=paste0(unique(temp$`Indicator Name`)),
                         # margin=list(t=60,b=135,l=0,r=0,pad=0),
                         margin=list(l=50,r=50,b=250,t=100,pad=0),
                         xaxis=list(title=""),
                         yaxis=list(title=""),
                         font=font_style,
                         showlegend=FALSE) %>%
          plotly::add_text(text=paste("Rank:",format_bignum(temp$rank)),textposition="right")%>%
          plotly::animation_opts(frame=1000,easing="linear",redraw=TRUE,mode="immediate")
      }
    })
    output$plot_map<-plotly::renderPlotly({
      g<-list(showframe=FALSE,showcoastlines=TRUE,projection=list(type='Mercator'))
      temp<-mfi[mfi$`Indicator Name` %in% input$indicator_map,]
      # temp<-mfi[mfi$`Indicator Name` %in% "Population, total",]
      # temp$Region[temp$Region==""]<-NA
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
                       margin=list(l=50,r=50,b=250,t=100,pad=0),
                       legend=list(orientation="h",xanchor="center",x=.5,y=1),
                       title=paste("Indicator:",input$indicator_map),
                       xaxis=list(title=""),
                       yaxis=list(title=""),
                       geo=g,
                       font=font_style)%>%
        plotly::animation_opts(frame=1000,easing="linear",redraw=TRUE,mode="immediate")
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
                      ids=~temp$`Country Name`,
                      text=~paste("\nContinent=",temp$Region,
                                  "\nCountry=",temp$`Country Name`),
                      type="scatter",
                      mode="markers",
                      fill=~'',
                      marker=list(sizemode='diameter'),
                      # colors=colors,
                      width=(as.numeric(input$dimension[1])-30),
                      height=(as.numeric(input$dimension[2])-120)) %>%
        plotly::layout(autosize=TRUE,
                       showlegend=TRUE,
                       margin=list(l=50,r=50,b=250,t=100,pad=0),
                       # legend=list(orientation="v",xanchor="center",x=.5,y=1),
                       title="",
                       xaxis=list(title=list(text=unique(input$indicator_cor1),standoff=3)),
                       yaxis=list(title=unique(input$indicator_cor2)),
                       font=font_style)%>%
        plotly::animation_opts(frame=500,easing="linear",redraw=TRUE,mode="afterall")
    })
    output$index_table=DT::renderDataTable({
      data<-data.frame(Indicator=unique(mfi$`Indicator Name`))
      result<-DT::datatable(data,options=list(paging=FALSE))
      DT::formatStyle(result,names(result),0,target='row',lineHeight='80%')
    })
  }
  ##########################################################################################
  # 
  ##########################################################################################
  shinyApp(ui = ui, server = server)
}

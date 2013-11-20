library(shiny)
library(ggplot2)
library(ggmap)
library(RJSONIO)
library(png)
library(grid)
library(RCurl)
library(plyr)

## Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Reactive Functions
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ## Mini Function
  mini.unlist <- function(temp.data) {
    temp.data <- unlist(temp.data)
    output <- data.frame(
      category = temp.data[1],
      #streetid = temp.data[4],
      streetname = temp.data[7],
      latitude = as.numeric(temp.data[5]),
      longitude = as.numeric(temp.data[8]),
      month = temp.data[10],
      type = temp.data[11])
    return(output)
  }
  
  ## Get Geocode
  map.geocode <- reactive({
    suppressMessages(data.frame(geocode = geocode(input$poi)))
  })
  
  ## Define Period
  map.period <- reactive({
    format(seq(input$start, length=input$months, by="months"), "%Y-%m")
  })
  
  ## Create Data Framework
  create.df <- reactive({
    
    ## Use Reactive Functions
    temp.geocode <- map.geocode()
    temp.period <- map.period()
    
    ## Get Data
    for (item in temp.period) { 
      if (item == temp.period[1]) {
        df <- ldply(.data = fromJSON(getURL(paste0("http://data.police.uk/api/crimes-street/all-crime?lat=",
                                                   temp.geocode[2], "&lng=", temp.geocode[1],
                                                   "&date=", item))), .fun = mini.unlist)
      } else {
        df <- rbind(df, ldply(.data = fromJSON(getURL(paste0("http://data.police.uk/api/crimes-street/all-crime?lat=",
                                                             temp.geocode[2], "&lng=", temp.geocode[1],
                                                             "&date=", item))), .fun = mini.unlist))
      }
    }    
    
    ## Output
    df
  })
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 1 - Data Table
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$datatable <- renderDataTable({
    create.df()
  }, options = list(aLengthMenu = c(5, 10, 25, 50, 100, 500), iDisplayLength = 10))
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 2 - Weather Map
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$map <- renderPlot({
    
    ## Use Reactive Functions
    temp.geocode <- map.geocode()
    temp.period <- map.period()
    
    ## Get df
    df <- create.df()
    
    ## Create a data frame for the map center (point of interest)
    center.df <- data.frame(temp.geocode, location = input$poi)
    colnames(center.df) <- c("lon","lat","location")
    
    ## Download base map using {ggmap}
    ## Note that a PNG file "ggmapTemp.png" will be created
    ## The PNG is not needed for the analysis, you can delete it later
    temp.color <- "color"
    if (input$bw) {temp.color <- "bw"}
    
    temp.scale <- 1
    if (input$res) {temp.scale <- 2}
    
    map.base <- get_googlemap(
      as.matrix(temp.geocode),
      maptype = input$type, ## Map type as defined above (roadmap, terrain, satellite, hybrid)
      langauage = "en-EN",  ## Code Ref: http://msdn.microsoft.com/en-us/library/ms533052(v=vs.85).aspx
      zoom = input$zoom,            ## 14 is just about right for a 1-mile radius
      color = temp.color,   ## "color" or "bw" (black & white)
      scale = temp.scale,   ## Set it to 2 for high resolution output
    )
    
    ## Convert the base map into a ggplot object
    ## All added Cartesian coordinates to enable more geom options later on
    map.base <- ggmap(map.base, extend = "panel") + coord_cartesian() + coord_fixed(ratio = 1.5)
    
    ## Main ggplot
    map.final <- map.base  +    
      
      ## Create a density plot
      ## based on the ggmap's crime data example
      stat_density2d(aes(x = longitude, 
                         y = latitude, 
                         fill = ..level.., 
                         alpha = ..level..),
                     size = input$boundwidth, 
                     bins = input$bins,  ## Change and experiment with no. of bins
                     data = df, 
                     geom = "polygon", 
                     colour = input$boundcolour) +
      
      ## Configure the scale and panel
      scale_fill_gradient(low = input$low, high = input$high) +
      scale_alpha(range = input$alpharanage) +
      
      ## Title and labels    
      labs(x = "Longitude", y = "Latitude") +
      ggtitle(paste("Crimes around ", input$poi, 
                    " from ", temp.period[1],
                    " to ", temp.period[length(temp.period)], sep="")) +
      
      ## Other theme settings
      theme_bw() +
      theme(
        plot.title = element_text(size = 36, face = 'bold', vjust = 2),
        #title = element_text(face = 'bold'),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "none",
        #axis.text.x = element_text(size = 28),
        #axis.text.y = element_text(size = 28),
        #axis.title.x = element_text(size = 32),
        #axis.title.y = element_text(size = 32),
        strip.background = element_rect(fill = 'grey80'),
        strip.text = element_text(size = 26)
      )
    
    ## Use Watermark?  
    if (input$watermark & input$facet == "none") {
      map.final <- map.final + annotate("text", x = center.df$lon, y = -Inf, 
                                        label = "blenditbayes.blogspot.co.uk",
                                        vjust = -1.5, col = "steelblue", 
                                        cex = 12,
                                        fontface = "bold", alpha = 0.5)
    }
    
    ## Use Facet?
    if (input$facet == "type") {map.final <- map.final + facet_wrap(~ type)}
    if (input$facet == "month") {map.final <- map.final + facet_wrap(~ month)}
    if (input$facet == "category") {map.final <- map.final + facet_wrap(~ category)}
    
    ## Save data for next output
    save(df, center.df, map.final, file = "temp.Rdata")
    
    ## Final Print
    print(map.final)
    
  }, width = 1280, height = 1280)
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 3 - Other Plots
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$trends1 <- renderPlot({
    
    ## Use Reactive Functions
    temp.geocode <- map.geocode()
    temp.period <- map.period()
    
    ## Get df
    df <- create.df()
    
    ## Small Summary df
    #df2 <- ddply(df, .(category, month), summarise, total = length(category))
    
    ## Plot
    plot1 <- ggplot(df, aes(x = month, fill = category)) + 
      geom_bar(colour = "black") + facet_wrap(~ category) +
      labs(x = "Months", y = "Crime Records") + 
      ggtitle(paste("Crimes around ", input$poi, 
                    ": Trends from ", temp.period[1],
                    " to ", temp.period[length(temp.period)], sep="")) +
      theme_bw() +
      theme(
        plot.title = element_text(size = 36, face = 'bold', vjust = 2),
        #axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.x = element_blank(),
        axis.text = element_text(size = 24),
        axis.title.x = element_text(size = 32),
        axis.title.y = element_text(size = 32),
        axis.ticks.x = element_blank(),
        strip.background = element_rect(fill = 'grey80'),
        strip.text.x = element_text(size = 26),
        legend.position = "none",
        panel.grid = element_blank()
      )
    
    ## Print
    print(plot1)
    
  }, width = 1280, height = 1280)

})
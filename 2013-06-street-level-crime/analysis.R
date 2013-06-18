## =============================================================================
## List of Refernces
## =============================================================================

## The API - http://data.police.uk/api/docs/
## Google Map Icon - http://mapicons.nicolasmollet.com/ 


## =============================================================================
## Initiliase
## =============================================================================

## Set Working Directory (optional)
setwd("E:/Cloud_Services/Google Drive/Repo/blenditbayes/2013-06-street-level-crime")

## Load the following packages
library(ggplot2)
library(ggmap)
library(RJSONIO)
library(png)
library(grid)


## =============================================================================
## User-defined functions and wrappers
## =============================================================================

## A function to transform list object into a data frame
list2df <- function(temp.list) 
  {
  
  ## Flatten the list
  temp.data <- unlist(temp.list, recursive = T)
  
  ## Extract data and create a data frame
  output <- data.frame(
    category = temp.data[1],
    streetid = temp.data[4],
    streetname = temp.data[7],
    latitude = as.numeric(temp.data[5]),
    longitude = as.numeric(temp.data[8]),
    month = temp.data[10],
    type = temp.data[11])
  
  ## Return
  return(output)
  
}


## A function to download and convert data from API
get.data <- function(point.of.interest = "London Eye", ## Define a location
                     period = c("2013-01","2013-02","2013-03")) ## YYYY-MM
  {
  ## Display a message
  cat("Downloading Geocode from Google Map API ... \n")
  
  ## Get Latitude and Longitute of a location using {ggmap}
  target.geocode <- geocode(point.of.interest)
  
  ## Create a subfolder "data" to store downloaded data
  dir.create(file.path("data"), showWarnings = FALSE)
  
  ## Display a message
  cat("Downloading data from UK Police API ...\n")

  ## Create an empty data frame
  data.df <- c()  
  
  ## A loop for getting data for each month
  for (item in period) {
    
    ## Generate specific URL for the API
    target.url <- paste0("http://data.police.uk/api/crimes-street/all-crime?lat=",
                         target.geocode$lat, "&lng=", target.geocode$lon,
                         "&date=", item)
    
    ## Download JSON using API
    download.file(target.url, "./data/data.json", quiet = TRUE, mode = "wb")
    
    ## Read JSON and convert it into a list using {RJSONIO}
    data.list <- fromJSON("./data/data.json")
    
    ## Convert the list into a data frame (slow - improve it in next version)
    temp.df <- c()
    for (n.list in 1:length(data.list)) {
      temp.df <- rbind(temp.df, list2df(data.list[n.list]))
    }
    
    ## Stack the temporary data frame
    data.df <- rbind(data.df, temp.df)
    
  }
  
  ## Return the data frame
  return(data.df)
  
}


## A function to visualise the data
visualise.data <- function(data.df,  ## data frame from the "get.data" function
                           point.of.interest = "London Eye",
                           period = c("2013-01","2013-02","2013-03"),
                           type.map = "roadmap", ## "Or terrain, satellite, hybrid
                           type.facet = NA, ## month, category, type
                           type.print = "panel", ## panel, window or NA
                           output.plot = TRUE) ## If true, return a ggplot object
  {
  ## Display a message
  cat("Downloading data from Google Map API ...\n")
  
  ## Get Latitude and Longitute of a location using {ggmap}
  target.geocode <- geocode(point.of.interest)
  
  ## Create a data frame for the map center (point of interest)
  center.df <- data.frame(target.geocode, location = point.of.interest)
  
  
  ## Download
  dir.create(file.path("data"), showWarnings = FALSE)  ## Create a subfolder
  download.file("http://woobe.bitbucket.org/images/blenditbayes/star_marker.png",
                destfile = "./data/star_marker.png", mode = "wb")
  marker.image <- readPNG("./data/star_marker.png")
  
  ## Download base map using {ggmap}
  ## Note that a PNG file "ggmapTemp.png" will be created
  ## The PNG is not needed for the analysis, you can delete it later
  map.base <- get_googlemap(
    as.matrix(target.geocode),
    maptype = type.map,   ## Map type as defined above (roadmap, terrain, satellite, hybrid)
    langauage = "en-EN",  ## Code Ref: http://msdn.microsoft.com/en-us/library/ms533052(v=vs.85).aspx
    zoom = 14,            ## 14 is just about right for a 1-mile radius
    color = "bw",         ## "color" or "bw" (black & white)
    scale = 2,            ## Set it to 2 for high resolution output
    )
  
  ## Convert the base map into a ggplot object
  ## All added Cartesian coordinates to enable more geom options later on
  map.ggmap <- ggmap(map.base, extend = "panel") + coord_cartesian()
  
  ## Display a message
  cat("Creating a ggplot object ...\n")
  
  ## Various display settings for the ggplot object
  main.plot <- map.ggmap  +    
    
    ## Create a density plot
    ## based on the ggmap's crime data example
    stat_density2d(aes(x = longitude, 
                       y = latitude, 
                       fill = ..level.., 
                       alpha = ..level..),
                   size = 0.01, 
                   bins = 15,  ## Change and experiment with no. of bins
                   data = data.df, 
                   geom = "polygon", 
                   colour = "grey95") +
    
    ## Configure the scale and panel
    scale_fill_gradient(low = "yellow", high = "red") +
    scale_alpha(range = c(.15, .45), guide = FALSE) +  ## Change and experiment differnet values
    guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10)) +
    guides(size = guide_legend(override.aes = list(size = 8))) +
    
    ## Title and labels    
    labs(x = "Longitude", y = "Latitude") +
    ggtitle(paste("Crimes around ",point.of.interest, 
                  " from ", period[1],
                  " to ", period[length(period)])) +
    
    ## Other theme settings
    theme_bw() +
    theme(
      title = element_text(size = 16, face = 'bold'),
      axis.text.x = element_text(size = 14),
      axis.text.y = element_text(size = 14),
      axis.title.x = element_text(size = 16),
      axis.title.y = element_text(size = 16),
      legend.title = element_text(size = 14, face = 'bold'),
      legend.text = element_text(size = 12),
      strip.background = element_rect(fill = 'grey80'),
      strip.text.x = element_text(size = 12)
    ) +
    
    ## Add star marker in center
    annotation_raster(marker.image, 
                      xmin = center.df$lon-0.00075,
                      xmax = center.df$lon+0.00075,
                      ymin = center.df$lat-0.0005,
                      ymax = center.df$lat+0.0005,
                      interpolate = TRUE) +
    geom_text(aes(lon,lat), data = center.df, 
              label = point.of.interest, 
              vjust = 2, colour = "steelblue",
              fontface = "bold", alpha = 0.75) +
    
    ## Add watermark
    annotate("text", x = center.df$lon, y = -Inf, 
             label = "blenditbayes.blogspot.co.uk",
             vjust = -1.5, col = "steelblue", cex = 6,
             fontface = "bold", alpha = 0.75)
  
  ## Use facet?
  if (is.na(type.facet)) {
    final.plot <- main.plot
  } else {
    if (type.facet == "month") {final.plot <- main.plot + facet_wrap(~ month)}
    if (type.facet == "category") {final.plot <- main.plot + facet_wrap(~ category)}
    if (type.facet == "type") {final.plot <- main.plot + facet_wrap(~ type)}  
  }
  
  ## Print to panel or window?
  if (is.na(type.print) == FALSE) {
    if (type.print == "panel") {print(final.plot)}
    if (type.print == "window") {windows(); print(final.plot)}  
  }
  
  ## Return
  if (output.plot) {return(final.plot)}
  
}


## A Wrapper to download and visualise street level crime data
crimeplot.wrapper <- function(point.of.interest = "London Eye",
                              period = c("2013-01","2013-02","2013-03"),
                              type.map = "roadmap",
                              type.facet = NA,
                              type.print = NA,
                              output.plot = TRUE,
                              output.filename = NULL,
                              output.size = c(700,700)) 
  {
  ## Get data
  data.df <- get.data(point.of.interest, period)
  
  ## Visualise data
  final.plot <- visualise.data(data.df,  ## From previous step
                               point.of.interest,
                               period,
                               type.map,
                               type.facet,
                               type.print,
                               output.plot)
  
  ## Print it out to a png file
  if (output.plot) {
    dir.create(file.path("output"), showWarnings = FALSE)
    png(file=paste0("./output/",output.filename), 
        width = output.size[1], height = output.size[2], 
        units="px", type="cairo")
    print(final.plot)
    dev.off()
  }
  
  ## Return the ggplot object
  if (output.plot) {return(final.plot)}
  
}


## =============================================================================
## Example 1 - Visualise all crimes within a one-mile radius of London Eye
##             from Jan-2012 to Mar-2012
## =============================================================================

## Define the period
ex1.period <- format(seq(as.Date("2012-01-01"), length=1, by="months"), "%Y-%m")

ex1.plot <- crimeplot.wrapper(point.of.interest = "London Eye",
                              period = ex1.period,
                              type.map = "roadmap",
                              output.filename = "ex1.png") 
                  

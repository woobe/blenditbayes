## =============================================================================
## The #rBlocks Experiements - Pixelation
## =============================================================================

## Load EBImage (install if needed)
if (!suppressMessages(require(EBImage))) {
  source("http://bioconductor.org/biocLite.R")
  biocLite("EBImage")
}
suppressMessages(library(EBImage))


## Load other packages
suppressMessages(library(RColorBrewer))
suppressMessages(library(animation))
suppressMessages(library(rblocks))


## Core Parameters
set.seed(1234)      # for reproducible results
num_pixel <- 50     # Height and Width (only resize to a square for now)


## Download the "R" image from my imgur account
download.file("http://i.imgur.com/UYOzCBc.png", 
              destfile = "R.png", 
              method = "wget", 
              quiet = TRUE, 
              mode = "w")


## Read and resize image
img_raw <- resize(readImage("R.png"), w = num_pixel, h = num_pixel)


## Convert into Greyscale 256 (0-255)
## need to add 1 for data slicing and then t() to correct rotation
img_grey <- channel(img_raw, "grey")
img_mat <- t(round((1-imageData(img_grey)) * 255, digits = 0) + 1)  


## Create block template
block_template <- make_block(matrix(1, num_pixel, num_pixel))


## Create sets of colours (un-comment to enable more)
set_colour <- list(
  #Accent <- colorRampPalette(brewer.pal(8,"Accent"), interpolate = "spline")(256),
  #Dark2 <- colorRampPalette(brewer.pal(8,"Dark2"), interpolate = "spline")(256),
  #Paired <- colorRampPalette(brewer.pal(12,"Paired"), interpolate = "spline")(256),
  #Set1 <- colorRampPalette(brewer.pal(9,"Set1"), interpolate = "spline")(256),
  #Set2 <- colorRampPalette(brewer.pal(8,"Set2"), interpolate = "spline")(256),
  #Set3 <- colorRampPalette(brewer.pal(12,"Set3"), interpolate = "spline")(256),
  #Pastel1 <- colorRampPalette(brewer.pal(9,"Pastel1"), interpolate = "spline")(256),
  #Pastel2 <- colorRampPalette(brewer.pal(8,"Pastel2"), interpolate = "spline")(256),
  Blues <- colorRampPalette(brewer.pal(9,"Blues"), interpolate = "spline")(256),
  BuGn <- colorRampPalette(brewer.pal(9,"BuGn"), interpolate = "spline")(256),
  BuPu <- colorRampPalette(brewer.pal(9,"BuPu"), interpolate = "spline")(256),
  GnBu <- colorRampPalette(brewer.pal(9,"GnBu"), interpolate = "spline")(256),
  Greens <- colorRampPalette(brewer.pal(9,"Greens"), interpolate = "spline")(256),
  Greys <- colorRampPalette(brewer.pal(9,"Greys"), interpolate = "spline")(256),
  Oranges <- colorRampPalette(brewer.pal(9,"Oranges"), interpolate = "spline")(256),
  OrRd <- colorRampPalette(brewer.pal(9,"OrRd"), interpolate = "spline")(256),
  PuBu <- colorRampPalette(brewer.pal(9,"PuBu"), interpolate = "spline")(256),
  #PuBuGn <- colorRampPalette(brewer.pal(9,"PuBuGn"), interpolate = "spline")(256),
  PuRd <- colorRampPalette(brewer.pal(9,"PuRd"), interpolate = "spline")(256),
  Purples <- colorRampPalette(brewer.pal(9,"Purples"), interpolate = "spline")(256),
  RdPu <- colorRampPalette(brewer.pal(9,"RdPu"), interpolate = "spline")(256),
  Reds <- colorRampPalette(brewer.pal(9,"Reds"), interpolate = "spline")(256),
  YlGn <- colorRampPalette(brewer.pal(9,"YlGn"), interpolate = "spline")(256))
#YlGnBu <- colorRampPalette(brewer.pal(9,"YlGnBu"), interpolate = "spline")(256),
#YlOrBr <- colorRampPalette(brewer.pal(9,"YlOrBr"), interpolate = "spline")(256),
#YlOrRd <- colorRampPalette(brewer.pal(9,"YlOrRd"), interpolate = "spline")(256),
#BrBG <- colorRampPalette(brewer.pal(9,"BrBG"), interpolate = "spline")(256),
#PiYG <- colorRampPalette(brewer.pal(9,"PiYG"), interpolate = "spline")(256),
#PRGn <- colorRampPalette(brewer.pal(9,"PRGn"), interpolate = "spline")(256),
#PuOr <- colorRampPalette(brewer.pal(9,"PuOr"), interpolate = "spline")(256),
#RdBu <- colorRampPalette(brewer.pal(9,"RdBu"), interpolate = "spline")(256),
#RdGy <- colorRampPalette(brewer.pal(9,"RdGy"), interpolate = "spline")(256),
#RdYlBu <- colorRampPalette(brewer.pal(9,"RdYlBu"), interpolate = "spline")(256),
#RdYlGn <- colorRampPalette(brewer.pal(9,"RdYlGn"), interpolate = "spline")(256),
#Spectral <- colorRampPalette(brewer.pal(9,"Spectral"), interpolate = "spline")(256))


## Identify unique colours
colour_unique <- sort(unique(as.integer(img_mat)))


## Randomise choices
## set.seed(1234)  ## set seed if you like
set_rand <- sample(length(set_colour), length(set_colour))


## Animate it
saveGIF({
  
  for (n_frame in 1:length(set_rand)) {
    
    ## Pick the colour set
    n_set <- set_rand[n_frame]
    use_colour <- unlist(set_colour[n_set])
    
    ## Create rblock template
    block_temp <- block_template
    
    ## Update colours
    for (n_colour in 1:length(colour_unique)) {
      block_temp[which(img_mat == colour_unique[n_colour])] <- use_colour[as.integer(colour_unique[n_colour])]
    }
    
    ## Display 
    display(block_temp)
  }
  
}, movie.name = "test.gif", interval = 0.25, ani.width = 500, ani.height = 500)
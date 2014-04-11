## =============================================================================
## The #rBlocks Experiements - Pixelation (function)
## =============================================================================

## Load EBImage (install if needed)
if (!suppressMessages(require(EBImage))) {
  source("http://bioconductor.org/biocLite.R")
  biocLite("EBImage")
}

## Load packages
suppressMessages(library(animation))
suppressMessages(library(rblocks))

## Function - pixelate
pixelate <- function(name_input = NULL, 
                     name_output = "output.gif",
                     pixel_seq = seq(5, 75, 5),
                     gif_interval = 0.15, 
                     gif_width = 500, 
                     gif_height = 500,
                     gif_reverse = TRUE) {
  
  ## Read Image
  img_raw <- readImage(name_input)
  
  ## Add reversed pixel sequence if needed
  if (gif_reverse) {
    pixel_rev <- sort(pixel_seq[which(pixel_seq != min(pixel_seq) & 
                                        pixel_seq != max(pixel_seq))], 
                      decreasing = T)  
    pixel_seq <- c(pixel_seq, pixel_rev)
  }
  
  ## Resize, pixelate and animate
  saveGIF({
    
    for (n_seq in 1:length(pixel_seq)) {
      
      ## Reisze
      img_resized <- resize(img_raw, w = pixel_seq[n_seq], h = pixel_seq[n_seq])
      
      ## Convert to hex colour and rotate with t()
      img_hex <- t(channel(img_resized, "x11"))
      
      ## Create rBlocks
      block <- make_block(matrix(NA, pixel_seq[n_seq], pixel_seq[n_seq]))
      
      ## Update Colours
      block[,] <- img_hex[,]
      
      ## Display rBlocks for animation
      display(block)
      
    }
    
    
  }, 
  movie.name = name_output, 
  interval   = gif_interval, 
  nmax       = 100,
  ani.width  = gif_width, 
  ani.height = gif_height)
  
  
}


## Example 1 - rCrimemap (http://i.imgur.com/FEZa0Ik.png)
download.file("http://i.imgur.com/FEZa0Ik.png", 
              destfile = "rcmap.png", 
              method = "wget", 
              quiet = TRUE, 
              mode = "w")
pixelate("rcmap.png") ## output: http://i.imgur.com/NhvaICA.gif


## Example 2 - http://i.imgur.com/0xpCfrh.jpg ## slidify logo 
download.file("http://i.imgur.com/0xpCfrh.jpg", 
              destfile = "slidify_logo_notext.jpg", 
              method = "wget", 
              quiet = TRUE, 
              mode = "w")

pixelate("slidify_logo_notext.jpg")  ## output: http://i.imgur.com/Ic91789.gif


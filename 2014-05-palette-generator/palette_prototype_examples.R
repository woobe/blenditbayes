## =============================================================================
## Code used for blog post "Towards (Yet) Another R Colour Palette Generator. Step One: Quentin Tarantino"
## URl: http://blenditbayes.blogspot.co.uk/2014/05/towards-yet-another-r-colour-palette.html
## =============================================================================

## Load Packages
library(EBImage)   # available on Bioconductor
library(rPlotter)  # https://github.com/woobe/rPlotter


## =============================================================================
## Example One: R Logo
## =============================================================================

## Define the image location (R Logo)
img_R <- "http://developer.r-project.org/Logo/Rlogo-1.png"

## Plot and save as PNG
png("example_R.png", width = 1000, height = 250, res = 150)
par(mfrow = c(1,4))
display(readImage(img_R), method = "raster")
set.seed(1234)
pie(rep(1, 3), col = extract_colours(img_R, 3)) # extract 3 dominant colours
pie(rep(1, 5), col = extract_colours(img_R, 5)) # extract 5 dominant colours
pie(rep(1, 7), col = extract_colours(img_R, 7)) # extract 7 dominant colours
par(mfrow = c(1,1))
dev.off()


## =============================================================================
## Example Two: Kill Bill
## =============================================================================

## Define the image location (Kill Bill Poster)
img_kb <- "http://www.moviegoods.com/Assets/product_images/1010/477803.1010.A.jpg"

## Plot and save as PNG
png("example_kb.png", width = 1000, height = 250, res = 150)
par(mfrow = c(1,4))
display(readImage(img_kb), method = "raster")
set.seed(1234)
pie(rep(1, 3), col = extract_colours(img_kb, 3)) # extract 3 dominant colours
pie(rep(1, 5), col = extract_colours(img_kb, 5)) # extract 5 dominant colours
pie(rep(1, 7), col = extract_colours(img_kb, 7)) # extract 7 dominant colours
par(mfrow = c(1,1))
dev.off()


## =============================================================================
## Example Three: Palette Tarantino
## =============================================================================

## Define a list of images from Tarantino's movies
lst_tar <- list(
  reservoir_dogs = "http://filmhash.files.wordpress.com/2011/06/reservoir-dogs-051.jpg",
  pulp_fiction = "http://www.scoutlondon.com/blog/wp-content/uploads/2012/05/Pulp-Fiction.jpg",
  kill_bill = "http://www.moviegoods.com/Assets/product_images/1010/477803.1010.A.jpg",
  django = "http://www.comingsoon.net/nextraimages/djangounchainednewposter.jpg"
  )

## Create palette for each image and save them all into one PNG
png("example_tarantino.png", width = 1000, height = 1000, res = 150)
par(mfrow = c(4,4))

for (n_tar in 1:length(lst_tar)) {
  tmp_url <- unlist(lst_tar[n_tar])
  if (n_tar %% 2 != 0) display(readImage(tmp_url), method = "raster")
  set.seed(1234)
  pie(rep(1, 3), col = extract_colours(tmp_url, 3))
  pie(rep(1, 5), col = extract_colours(tmp_url, 5))
  pie(rep(1, 7), col = extract_colours(tmp_url, 7))
  if (n_tar %% 2 == 0) display(readImage(tmp_url), method = "raster")
}

par(mfrow = c(1,1))
dev.off()


## =============================================================================
## Example Four: Palette Simpsons
## =============================================================================

## Define a list of images from Simpsons' main characters
lst_sim <- list(
  homer = "http://haphappy.com/wp-content/uploads/2011/03/homerbeer2.png",
  march = "http://img3.wikia.nocookie.net/__cb20131213015321/epic-rap-battles-of-cartoons/images/d/de/Marge-simpson1.png",
  bart = "http://www.allfreevectors.com/images/Free%20Vector%20Bart%20Simpson%2002%20The%20Simpsons2980.jpg",
  lisa = "http://s3.amazonaws.com/rapgenius/Lisa_Simpson.png",
  maggie = "http://www.vectorjunky.com/gallery/m/Maggie-Simpson-01-The-Simpsons.jpg"
)

## Create palette for each image and save them all into one PNG
png("example_simpsons.png", width = 1000, height = 1250, res = 150)
par(mfrow = c(5,4))

for (n_sim in 1:length(lst_sim)) {
  tmp_url <- unlist(lst_sim[n_sim])
  if (n_sim %% 2 != 0) display(readImage(tmp_url), method = "raster")
  set.seed(1234)
  pie(rep(1, 3), col = extract_colours(tmp_url, 3))
  pie(rep(1, 5), col = extract_colours(tmp_url, 5))
  pie(rep(1, 7), col = extract_colours(tmp_url, 7))
  if (n_sim %% 2 == 0) display(readImage(tmp_url), method = "raster")
}

par(mfrow = c(1,1))
dev.off()

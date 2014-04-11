## =============================================================================
## The #rBlocks Experiements - Air Passengers
## =============================================================================

## Load packages
library(rblocks)
library(RColorBrewer)


## =============================================================================
## rBlocks #1 - AirPassengers with 'YlOrRd' palette
## =============================================================================

## Using the classic AirPassengers dataset
mat_air <- matrix(AirPassengers)
mat_value <- matrix(mat_air, ncol = 12, byrow = TRUE)

## Assign colours to numerical values
colour_value <- matrix(NA, nrow(mat_air))
colour_value[order(mat_air),] <- colorRampPalette(brewer.pal(9,"YlOrRd"))(nrow(mat_air))
colour_value <- matrix(colour_value, ncol = 12, byrow = TRUE)

## Assign colours to years
mat_year <- matrix(1949:1960)
colour_year <- colorRampPalette(brewer.pal(6,"Greys"))(nrow(mat_year))

## Create df
df_air <- data.frame(mat_year, mat_value)
colnames(df_air) <- c("Year",
                      "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

## Make block
block_air <- make_block(df_air)

## Update Colours
block_air[, 1] <- as.character(colour_year)
block_air[, -1] <- as.character(colour_value)

## Plot
display(block_air)


## =============================================================================
## rBlocks #2 - AirPassengers with funky RSkittleBrewer
## =============================================================================

## Using the RSkittleBrewer
if (!require(devtools)) install.packages("devtools")
if (!require(RSkittleBrewer)) {
  devtools::install_github('RSkittleBrewer', 'alyssafrazee')
  require(RSkittleBrewer)
}
  
## Assign Skittle (original) colours to numerical values
colour_skittle <- RSkittleBrewer('original')
colour_value <- matrix(NA, nrow(mat_air))
colour_value[order(mat_air, decreasing = T),] <- colorRampPalette(colour_skittle)(nrow(mat_air))
colour_value <- matrix(colour_value, ncol = 12, byrow = TRUE)

## Make block
block_air_skittle <- make_block(df_air)

## Update Colours
block_air_skittle[, 1] <- as.character(colour_year)
block_air_skittle[, -1] <- as.character(colour_value)

## Plot
display(block_air_skittle)


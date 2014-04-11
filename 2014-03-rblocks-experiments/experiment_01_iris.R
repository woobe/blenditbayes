## =============================================================================
## The #rBlocks Experiements - Iris
## =============================================================================

## Load packages (see https://github.com/ramnathv/rblocks)
library(caret)
library(rblocks)         
library(RColorBrewer)

## Sampling with caret (to get exactly two samples from each species)
set.seed(1234)
row_samp <- createDataPartition(iris$Species, p = 0.021, list = F)

## Make block
iris_samp <- iris[row_samp,]
iris_block <- make_block(iris_samp)

## Shorten column names for better display
colnames(iris_block) <- c("Sepal.L", "Sepal.W", "Petal.L", "Petal.W", "Species")

## Update colours for Species (ref: http://en.wikipedia.org/wiki/File:Anderson%27s_Iris_data_set.png)
iris_block[which(iris_samp$Species == "setosa"),]$Species <- "red"
iris_block[which(iris_samp$Species == "versicolor"),]$Species <- "green"
iris_block[which(iris_samp$Species == "virginica"),]$Species <- "blue"

## Update colours for other variables
iris_block[order(iris_samp[,1]), 1] <- colorRampPalette(brewer.pal(6,"YlGn"))(length(row_samp))
iris_block[order(iris_samp[,2]), 2] <- colorRampPalette(brewer.pal(6,"Blues"))(length(row_samp))
iris_block[order(iris_samp[,3]), 3] <- colorRampPalette(brewer.pal(6,"Purples"))(length(row_samp))
iris_block[order(iris_samp[,4]), 4] <- colorRampPalette(brewer.pal(6,"Greys"))(length(row_samp))

## Plot
display(iris_block)
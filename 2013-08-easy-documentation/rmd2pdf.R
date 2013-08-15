## Convert Rmd into pdf

## Set working diectory
setwd("/media/woobe/SUPPORT/Repo/blenditbayes/2013-08-easy-documentation")

## Define filename
FILE <- "report"

## Convert .Rmd into .md
library(knitr)
knit2html(paste(FILE, ".Rmd", sep=""))

## Convert .md into .pdf
system(paste("pandoc -o ", FILE, ".pdf ", FILE, ".md", sep=""))
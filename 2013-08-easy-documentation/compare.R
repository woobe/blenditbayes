## Compare

## Set working diectory
setwd("/media/woobe/SUPPORT/Repo/blenditbayes/2013-08-easy-documentation")

## Load benchmark results
load("results_oldOpenBlas.rda")
load("results_newOpenBlas.rda")

## Load Packages
library(ggplot2)
library(xtable)

## Combine and create a new dataframe for report
compare.timing <- data.frame(timing.oldOpenBlas[,1:2], 
                             oldOpenBLAS = timing.oldOpenBlas[,3],
                             newOpenBlas = timing.newOpenBlas[,3])

diff <- matrix(NA, nrow=nrow(compare.timing), ncol=1)
for (n.row in 1:nrow(compare.timing)) { 
  
  temp.percent.diff <- (compare.timing[n.row,3]-compare.timing[n.row,4])/compare.timing[n.row,3]
  
  if (abs(temp.percent.diff) <= 0.025) {
    diff[n.row, 1] <- "<= 2.5%"
  } else { 
    if (compare.timing[n.row,3] > compare.timing[n.row,4]) {
      diff[n.row, 1] <- paste(round(compare.timing[n.row,3] / compare.timing[n.row,4], digits=1), "x faster", sep="")
    } else {
      diff[n.row, 1] <- paste(round(compare.timing[n.row,4] / compare.timing[n.row,3], digits=1), "x slower", sep="")
    }  
  }
}
compare.timing <- data.frame(compare.timing, diff)
colnames(compare.timing) <- c("Group","Test","v0.2.6","v0.2.8","Difference")
compare.timing[,2] <- paste(strtrim(compare.timing[,2], 15), "...")










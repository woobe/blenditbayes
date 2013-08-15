## =============================================================================
## R Environment Settings
## =============================================================================

## Set WD (Change it to your own)
setwd("/media/woobe/SUPPORT/Repo/blenditbayes/2013-08-easy-documentation")

## Load the modified r25 benchmark function
source("R-benchmark-25-modified.R") 


## =============================================================================
## Test 1 - Run benchmark with OpenBLAS version 0.2.6-1~exp1
## =============================================================================

timing.oldOpenBlas <- r25()
save(timing.oldOpenBlas, file="results_oldOpenBlas.rda")
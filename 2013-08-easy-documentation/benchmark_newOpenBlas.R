## =============================================================================
## R Environment Settings
## =============================================================================

## Set WD (Change it to your own)
setwd("/media/woobe/SUPPORT/Repo/blenditbayes/2013-08-easy-documentation")

## Load the modified r25 benchmark function
source("R-benchmark-25-modified.R") 

## =============================================================================
## Test 2 - Run benchmark with OpenBLAS latest version 0.2.xxx
## =============================================================================

timing.newOpenBlas <- r25()
save(timing.newOpenBlas, file="results_newOpenBlas.rda")


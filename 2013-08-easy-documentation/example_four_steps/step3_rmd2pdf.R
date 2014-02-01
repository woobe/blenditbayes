## =============================================================================
## Code-generated Report
## Step 3: Converting .Rmd into .pdf
## =============================================================================

## Set working diectory
if (Sys.info()[1] == "Windows") {setwd("D:/Repo/r-sandbox/code-generated-report")}
if (Sys.info()[1] == "Linux") {setwd("/media/woobe/SUPPORT/Repo/r-sandbox/code-generated-report")}


## A Wrapper Function
rmd2pdf <- function() {
  
  ## Display
  cat("\n===== Generating Report with R =====\n")
  
  ## Define filename
  filename <- "step2_doc"
  
  ## Convert .Rmd into .md
  library(knitr)
  cat("    Converting .Rmd into .md ...\n")
  knit2html(paste0(filename, ".Rmd"), quiet=TRUE)
  
  ## Convert .md into .pdf
  cat("    Converting .md into .pdf ...\n")
  system(paste0("pandoc -o ", "step4_output.pdf ", filename, ".md"))
  
  ## Clean up files
  cat("    Cleaning up ...\n")
  unlink(paste0(filename, ".md"))
  unlink(paste0(filename, ".html"))
  unlink("figure", recursive = TRUE, force = TRUE)
  
  ## Display
  cat("============== Done!! ==============\n\n")
}


## Use the wrapper and suppress messages
suppressMessages(rmd2pdf())


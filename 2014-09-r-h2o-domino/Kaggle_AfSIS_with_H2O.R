## =============================================================================
## R + H2O + Domino Stater Code
## =============================================================================

## Data Source: https://www.kaggle.com/c/afsis-soil-properties

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Install Domino Bleeding Edge Version on Domino
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Specify H2O version here
h2o_ver <- "1511"

## Install H2O
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.us.r-project.org"; options(repos = r)})
txt_repo <- (c(paste0(paste0("http://s3.amazonaws.com/h2o-release/h2o/master/",
                             h2o_ver),"/R"),
               getOption("repos")))
install.packages("h2o", repos = txt_repo, quiet = TRUE)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Initiate and Connect to a Local H2O Cluster on Domino
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(h2o)
localH2O <- h2o.init(max_mem_size = '1g') ## using a max 1GB of RAM


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Import Data
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Get the local path on Domino
path_cloud <- getwd()

## Define other paths
path_train <- paste0(path_cloud, "/data/train.zip")
path_test <- paste0(path_cloud, "/data/test.zip")
path_submission <- paste0(path_cloud, "/data/sample_submission.csv")
path_output <- paste0(path_cloud, "/results/my_Kaggle_submission.csv")

## Import Data to H2O Cluster
train_hex <- h2o.importFile(localH2O, path = path_train)
test_hex <- h2o.importFile(localH2O, path = path_test)
raw_sub <- read.csv(path_submission)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Train a Deep Neural Networks model for each variable
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Split the dataset into 80:20 for training and validation
train_hex_split <- h2o.splitFrame(train_hex, ratios = 0.8, shuffle = TRUE)

## One Variable at at Time
ls_label <- c("Ca", "P", "pH", "SOC", "Sand")

for (n_label in 1:5) {

  ## Display
  cat("\n\nNow training a DNN model for", ls_label[n_label], "...\n")

  ## Train a DNN
  model <- h2o.deeplearning(x = 2:3595,
                            y = (3595 + n_label),
                            data = train_hex_split[[1]],
                            validation = train_hex_split[[2]],
                            activation = "Rectifier",
                            hidden = c(50, 50, 50),
                            epochs = 100,
                            classification = FALSE,
                            balance_classes = FALSE)

  ## Print the Model Summary
  print(model)

  ## Use the model for prediction and store the results in submission template
  raw_sub[, (n_label + 1)] <- as.matrix(h2o.predict(model, test_hex))

}


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Save the results as a CSV
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

write.csv(raw_sub, file = path_output, row.names = FALSE)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Print System and Session Info
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

print(sessionInfo())

print(Sys.info())

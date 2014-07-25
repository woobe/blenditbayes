## =============================================================================
## [BIB]: R + H2O Machine Learning Experiments
## =============================================================================

## Data Source References:
## MNIST Source Data
## Original Dataset: http://yann.lecun.com/exdb/mnist/
## CSV Version: http://www.pjreddie.com/projects/mnist-in-csv/
## Train Dataset: http://www.pjreddie.com/media/files/mnist_train.csv
## Test Dataset: http://www.pjreddie.com/media/files/mnist_test.csv


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Initialise R environment
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Set WD (Optional - I need this for my laptop)
setwd("/media/SUPPORT/Repo/blenditbayes/2014-07-h2o-experiments")

## Load all packages first
suppressMessages(library(h2o))
suppressMessages(library(caret))
suppressMessages(library(mlbench))
suppressMessages(library(ggplot2))
suppressMessages(library(reshape2))
suppressMessages(library(deepr))

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Initialise H2O Connection
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Start a local H2O cluster directly from R
# localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE)  # default settings with 1GB RAM
localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE,
                    Xmx = '2g') # cap it at max 2GB


## =============================================================================
## [Experiment 2]: MNIST 10-Class Classification
## =============================================================================

## Link MNIST Datasets
## Note: CSV files are not included with repo. Download the CSV files from the links above.
train_h2o <- h2o.importFile(localH2O, path = "/media/SUPPORT/Repo/blenditbayes/2014-07-h2o-experiments/data/mnist_train.csv")
test_h2o <- h2o.importFile(localH2O, path = "/media/SUPPORT/Repo/blenditbayes/2014-07-h2o-experiments/data/mnist_test.csv")
y_train <- as.factor(as.matrix(train_h2o[, 1]))
y_test <- as.factor(as.matrix(test_h2o[, 1]))


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## [Experiment 2A]: DNN without Regularization (Dropout)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Create an empty data frame for results
res <- data.frame(Training = NA, Test = NA, Duration = NA)

## Start the timer
tt <- start_timer()

## Train the model
model <- h2o.deeplearning(x = 2:785,  # column numbers for predictors
                          y = 1,   # column number for label
                          data = train_h2o,
                          activation = "Tanh",
                          balance_classes = TRUE,
                          hidden = c(100, 100, 100, 100, 100),  ## five hidden layers
                          epochs = 100)

## Evaluate performance
yhat_train <- h2o.predict(model, train_h2o)$predict
yhat_train <- as.factor(as.matrix(yhat_train))
yhat_test <- h2o.predict(model, test_h2o)$predict
yhat_test <- as.factor(as.matrix(yhat_test))

## Store Results
res[1, 1] <- round(confusionMatrix(yhat_train, y_train)$overall[1], 4)
res[1, 2] <- round(confusionMatrix(yhat_test, y_test)$overall[1], 4)
res[1, 3] <- stop_timer(tt)
print(res)

## Save results
save(res, file = 'results_h2o_dnn_exp_2.rda')


## =============================================================================
## [BIB]: R + H2O Machine Learning Experiments
## =============================================================================

## Data Source References:
## see package 'mlbench'

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
## For the first experiment, start the cluster with default 1GB RAM
localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Core Settings for the Experiments
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Define the number of runs (for each model)
## Increase this for more robust comparison
n_run <- 50
n_epochs <- 500

## Set seed
## Note: I found that the seed cannot control the randomness in H2O clusters
## but at least this should give you the same training/test data split I use.
## So set.seed(1234) is used just before all the data splitting steps below.


## =============================================================================
## [Experiment 1]: Breast Cancer Data (2-Class Classification)
## =============================================================================

## Variables needed for final results summary only
name_dat <- "Breast Cancer Data"
num_exp <- 1

## Load Breast Cancer data from 'mlbench'
data(BreastCancer)

## Convert data frame into H2O object
dat <- BreastCancer[, -1]  # remove the ID column
dat_h2o <- as.h2o(localH2O, dat, key = 'dat')

## Split 60/40 for Training/Test Dataset
set.seed(1234)
y_all <- as.matrix(dat_h2o$Class)
rand_folds <- createFolds(as.factor(y_all), k = 5)
row_train <- as.integer(unlist(rand_folds[1:3]))
row_test <- as.integer(unlist(rand_folds[4:5]))
y_train <- as.factor(y_all[row_train])
y_test <- as.factor(y_all[row_test])


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## [Experiment 1A]: DNN without Regularization (Dropout)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Create an empty data frame for results
res_tmp <- data.frame(Trial = 1:n_run, Training = NA, Test = NA, Duration = NA)

## Train model and evaluate performance for n times
cat("\n[Experiment 1A]: DNN without Regularization (Dropout) ...\n")

for (n in 1:n_run) {

  ## Display
  cat("Run", n, "out of", n_run, "...\n")

  ## Start the timer
  tt <- start_timer()

  ## Train the model
  model <- h2o.deeplearning(x = 1:9,  # column numbers for predictors
                            y = 10,   # column number for label
                            data = dat_h2o[row_train, ],
                            activation = "Tanh",
                            balance_classes = TRUE,
                            hidden = c(50,50,50),  ## three hidden layers
                            epochs = n_epochs)

  ## Evaluate performance
  yhat_train <- h2o.predict(model, dat_h2o[row_train, ])$predict
  yhat_train <- as.factor(as.matrix(yhat_train))
  yhat_test <- h2o.predict(model, dat_h2o[row_test, ])$predict
  yhat_test <- as.factor(as.matrix(yhat_test))

  ## Store Results
  res_tmp[n, 1] <- n
  res_tmp[n, 2] <- round(confusionMatrix(yhat_train, y_train)$overall[1], 4)
  res_tmp[n, 3] <- round(confusionMatrix(yhat_test, y_test)$overall[1], 4)
  res_tmp[n, 4] <- round(stop_timer(tt), 2)

}

## Store overall results
res_a <- data.frame(Model = "1A", res_tmp[, -1])
print(res_a)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## [Experiment 1B]: DNN with Dropout (Inputs/Hidden = 0%/50%)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Create an empty data frame for results
res_tmp <- data.frame(Trial = 1:n_run, Training = NA, Test = NA, Duration = NA)

## Train model and evaluate performance for n times
cat("\n[Experiment 1B]: DNN with Dropout (Inputs/Hidden = 0%/50%) ...\n")

for (n in 1:n_run) {

  ## Display
  cat("Run", n, "out of", n_run, "...\n")

  ## Start the timer
  tt <- start_timer()

  ## Train the model
  model <- h2o.deeplearning(x = 1:9,  # column numbers for predictors
                            y = 10,   # column number for label
                            data = dat_h2o[row_train, ],
                            activation = "TanhWithDropout",
                            input_dropout_ratio = 0,
                            hidden_dropout_ratios = c(0.5,0.5,0.5),
                            balance_classes = TRUE,
                            hidden = c(50,50,50),  ## three hidden layers
                            epochs = n_epochs)

  ## Evaluate performance
  yhat_train <- h2o.predict(model, dat_h2o[row_train, ])$predict
  yhat_train <- as.factor(as.matrix(yhat_train))
  yhat_test <- h2o.predict(model, dat_h2o[row_test, ])$predict
  yhat_test <- as.factor(as.matrix(yhat_test))

  ## Store Results
  res_tmp[n, 1] <- n
  res_tmp[n, 2] <- round(confusionMatrix(yhat_train, y_train)$overall[1], 4)
  res_tmp[n, 3] <- round(confusionMatrix(yhat_test, y_test)$overall[1], 4)
  res_tmp[n, 4] <- round(stop_timer(tt), 2)

}

## Store overall results
res_b <- data.frame(Model = "1B", res_tmp[, -1])
print(res_b)


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## [Experiment 1C]: DNN with Dropout (Inputs/Hidden = 10%/50%)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Create an empty data frame for results
res_tmp <- data.frame(Trial = 1:n_run, Training = NA, Test = NA, Duration = NA)

## Train model and evaluate performance for n times
cat("\n[Experiment 1C]: DNN with Dropout (Inputs/Hidden = 10%/50%) ...\n")

for (n in 1:n_run) {

  ## Display
  cat("Run", n, "out of", n_run, "...\n")

  ## Start the timer
  tt <- start_timer()

  ## Train the model
  model <- h2o.deeplearning(x = 1:9,  # column numbers for predictors
                            y = 10,   # column number for label
                            data = dat_h2o[row_train, ],
                            activation = "TanhWithDropout",
                            input_dropout_ratio = 0.1,
                            hidden_dropout_ratios = c(0.5,0.5,0.5),
                            balance_classes = TRUE,
                            hidden = c(50,50,50),  ## three hidden layers
                            epochs = n_epochs)

  ## Evaluate performance
  yhat_train <- h2o.predict(model, dat_h2o[row_train, ])$predict
  yhat_train <- as.factor(as.matrix(yhat_train))
  yhat_test <- h2o.predict(model, dat_h2o[row_test, ])$predict
  yhat_test <- as.factor(as.matrix(yhat_test))

  ## Store Results
  res_tmp[n, 1] <- n
  res_tmp[n, 2] <- round(confusionMatrix(yhat_train, y_train)$overall[1], 4)
  res_tmp[n, 3] <- round(confusionMatrix(yhat_test, y_test)$overall[1], 4)
  res_tmp[n, 4] <- round(stop_timer(tt), 2)

}

## Store overall results
res_c <- data.frame(Model = "1C", res_tmp[, -1])
print(res_c)



## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## [Experiment 1D]: DNN with Dropout (Inputs/Hidden = 20%/50%)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Create an empty data frame for results
res_tmp <- data.frame(Trial = 1:n_run, Training = NA, Test = NA, Duration = NA)

## Train model and evaluate performance for n times
cat("\n[Experiment 1D]: DNN with Dropout (Inputs/Hidden = 20%/50%) ...\n")

for (n in 1:n_run) {

  ## Display
  cat("Run", n, "out of", n_run, "...\n")

  ## Start the timer
  tt <- start_timer()

  ## Train the model
  model <- h2o.deeplearning(x = 1:9,  # column numbers for predictors
                            y = 10,   # column number for label
                            data = dat_h2o[row_train, ],
                            activation = "TanhWithDropout",
                            input_dropout_ratio = 0.2,
                            hidden_dropout_ratios = c(0.5,0.5,0.5),
                            balance_classes = TRUE,
                            hidden = c(50,50,50),  ## three hidden layers
                            epochs = n_epochs)

  ## Evaluate performance
  yhat_train <- h2o.predict(model, dat_h2o[row_train, ])$predict
  yhat_train <- as.factor(as.matrix(yhat_train))
  yhat_test <- h2o.predict(model, dat_h2o[row_test, ])$predict
  yhat_test <- as.factor(as.matrix(yhat_test))

  ## Store Results
  res_tmp[n, 1] <- n
  res_tmp[n, 2] <- round(confusionMatrix(yhat_train, y_train)$overall[1], 4)
  res_tmp[n, 3] <- round(confusionMatrix(yhat_test, y_test)$overall[1], 4)
  res_tmp[n, 4] <- round(stop_timer(tt), 2)

}

## Store overall results
res_d <- data.frame(Model = "1D", res_tmp[, -1])
print(res_d)



## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Summarise Results
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Combine
res_all <- rbind(res_a, res_b, res_c, res_d)

## Reshape2
res_acc <- melt(res_all,
                id.vars = c('Model'),
                measure.vars = c('Training', 'Test'))

res_time <- melt(res_all,
                id.vars = c('Model'),
                measure.vars = c('Duration'))

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Create ggplot
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

title_acc <- paste0("H2O Experiment ", num_exp, ": ", name_dat,
                    "\nComparing In-Sample and Out-of-Bag Prediction Accuracy from",
                    "\nDeep Neural Networks with Different Regularization Settings",
                    "\n(No. of Samples: Training - ", length(row_train), " (",
                    round(length(row_train) / length(y_all) * 100), "%)  Test - ",
                    length(row_test), " (", round(length(row_test) / length(y_all) * 100), "%))")

title_time <- paste0("H2O Experiment ", num_exp, ": ", name_dat,
                     "\nComparing Time Required for Convergence in the Training of",
                     "\nDeep Neural Networks with Different Regularization Settings",
                     "\n(No. of Samples: Training - ", length(row_train), " (",
                     round(length(row_train) / length(y_all) * 100), "%)  Test - ",
                     length(row_test), " (", round(length(row_test) / length(y_all) * 100), "%))")

## Prediction Accuracy
gg_acc <- ggplot(data = res_acc, aes(x = Model, y = value, fill = Model)) +
  #scale_colour_manual(name = "Config", values = pal_final) +
  #scale_fill_manual(name = "Config", values = pal_final) +
  geom_boxplot() +
  facet_grid(~ variable) +
  theme(title = element_text(size = 18, vjust = 2),
        strip.text = element_text(size = 14),
        axis.text = element_text(size = 14),
        axis.title.y = element_text(vjust = 0.75),
        axis.title.x = element_text(vjust = -0.5),
        legend.text = element_text(size = 14)) +
  ggtitle(title_acc) +
  xlab("Inputs/Hidden Dropout Ratio - 1A: 0%/0% - 1B: 0%/50% - 1C: 10%/50% - 1D: 20%/50%") +
  ylab("Performance: Prediction Accuracy (%)")

## Time Required for Training
gg_time <- ggplot(data = res_time, aes(x = Model, y = value, fill = Model)) +
  #scale_colour_manual(name = "Config", values = pal_final) +
  #scale_fill_manual(name = "Config", values = pal_final) +
  geom_boxplot() +
  theme(title = element_text(size = 18, vjust = 2),
        strip.text = element_text(size = 14),
        axis.text = element_text(size = 14),
        axis.title.y = element_text(vjust = 0.75),
        axis.title.x = element_text(vjust = -0.5),
        legend.text = element_text(size = 14)) +
  ggtitle(title_time) +
  xlab("Inputs/Hidden Dropout Ratio - 1A: 0%/0% - 1B: 0%/50% - 1C: 10%/50% - 1D: 20%/50%") +
  ylab("Time Required for Training (Seconds)")

## Save results
save(res_all, res_acc, res_time, gg_acc, gg_time, file = 'results_h2o_dnn_exp_1.rda')

## Print PNG
png(filename = 'exp_1_summary.png',
    width = 1500, height = 1000,
    res = 100)
print(gg_acc)
dev.off()

png(filename = 'exp_1_time.png',
    width = 1500, height = 1000,
    res = 100)
print(gg_time)
dev.off()



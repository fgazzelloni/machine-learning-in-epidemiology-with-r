# Fit a neural network to the heart data, then evaluate its predictions.
# Run from part2/. Model settings follow article section 2.2.3.

## ---- neural-data ----
# Load the patient measurements and outcome labels.
source("R/01-data.R")

## ---- neural-task ----
library(mlr3)

# Tell mlr3 which outcome to predict and which class means disease is present.
heart_task <- as_task_classif(heart,
  target = "heart_disease",
  positive = "present",
  id = "heart"
)

# Reuse the patients used to train and test the saved random forest.
split_record <- read.csv("outputs/split.csv")
split <- list(
  train = split_record$row_id[split_record$subset == "train"],
  test = split_record$row_id[split_record$subset == "test"]
)

## ---- neural-check ----
# Check that every patient belongs to exactly one group.
stopifnot(
  length(split$train) == 180L,
  length(split$test) == 90L,
  !anyDuplicated(c(split$train, split$test)),
  setequal(c(split$train, split$test), seq_len(nrow(heart)))
)

## ---- neural-inputs ----
# Exclude the outcome from the inputs. Keras needs numbers, so use 0/1 for
# binary categories and indicator columns for the others. An indicator is 1
# when a category applies and 0 otherwise. Together these give 22 inputs.
x_data <- heart[, setdiff(names(heart), "heart_disease")]
for (nm in c("sex", "fasting_blood_sugar", "exercise_induced_angina")) {
  x_data[[nm]] <- as.integer(x_data[[nm]]) - 1L
}
nominal <- names(x_data)[vapply(x_data, is.factor, logical(1))]
contrasts_full <- lapply(x_data[nominal], function(x) contrasts(x, contrasts = FALSE))
x <- model.matrix(~ . - 1, data = x_data, contrasts.arg = contrasts_full)
stopifnot(ncol(x) == 22L, all(is.finite(x)))

# Keras reserves the last 20% of training rows for validation.
# Calculate scaling from the other 80% only, keeping validation and test
# patients out of this calculation.
inner_n <- floor(length(split$train) * 0.8)
fit_rows <- split$train[seq_len(inner_n)]
continuous <- names(x_data)[vapply(x_data, is.numeric, logical(1))]
continuous <- setdiff(
  continuous,
  c("sex", "fasting_blood_sugar", "exercise_induced_angina")
)

# Subtract each measurement's mean and divide by its standard deviation.
# This puts measurements with different units on a comparable scale.
centre <- colMeans(x[fit_rows, continuous, drop = FALSE])
spread <- apply(x[fit_rows, continuous, drop = FALSE], 2, sd)
stopifnot(all(spread > 0))
x[, continuous] <- sweep(
  sweep(x[, continuous, drop = FALSE], 2, centre),
  2, spread, "/"
)

# Code the outcome as 1 for present and 0 for absent.
y <- as.integer(heart$heart_disease == "present")

## ---- neural-build ----
library(keras3)

# Fix the random starting point for the network.
set_random_seed(20261023)

# Pass 22 inputs through two hidden layers to one output probability.
# Dropout temporarily switches off some units during training to limit overfitting.
network <- keras_model_sequential(input_shape = c(22)) |>
  layer_dense(units = 64, activation = "relu") |>
  layer_dropout(rate = 0.4) |>
  layer_dense(units = 32, activation = "relu") |>
  layer_dropout(rate = 0.4) |>
  layer_dense(units = 1, activation = "sigmoid")

# Choose how to update the weights and measure prediction error.
# Binary cross-entropy is a loss for a two-class outcome.
compile(network,
  optimizer = optimizer_adam(learning_rate = 0.002),
  loss = "binary_crossentropy", metrics = "accuracy"
)

## ---- neural-fit ----
# An epoch is one pass through the fitting rows; batches contain 32 rows.
# Monitor validation loss and stop after 10 epochs without improvement,
# restoring the weights from the best validation epoch.
training <- fit(
  network,
  x[split$train, ],
  y[split$train],
  epochs = 50,
  batch_size = 32,
  validation_split = 0.2,
  verbose = 1,
  callbacks = list(callback_early_stopping(patience = 10, restore_best_weights = TRUE))
)

## ---- neural-history ----
# Compare training and validation loss as learning progresses.
plot(training)

## ---- neural-predict ----
# Predict unseen test patients. Use 0.5 as the cut-off for a present prediction.
prob <- as.numeric(predict(network, x[split$test, ], verbose = 0))
class <- ifelse(prob >= 0.5, "present", "absent")
accuracy <- mean(class == as.character(heart$heart_disease[split$test]))
accuracy

# Bring the Keras predictions into mlr3 for the same evaluation measures.
network_pred <- PredictionClassif$new(
  task = heart_task,
  row_ids = split$test,
  truth = heart_task$truth(rows = split$test),
  response = class,
  prob = cbind(present = prob, absent = 1 - prob)
)
network_pred$confusion
network_pred$score(msrs(c("classif.acc", "classif.tpr", "classif.tnr")))

## ---- neural-save ----
# Save this run's predictions and accuracy, replacing the previous saved files.
write.csv(
  data.frame(
    row_id = split$test, truth = heart$heart_disease[split$test],
    probability_present = prob,
    prediction = class
  ),
  "outputs/neural-predictions.csv",
  row.names = FALSE
)
write.csv(data.frame(accuracy = accuracy),
  "outputs/neural-accuracy.csv",
  row.names = FALSE
)

# Keep one training and validation loss value for each completed epoch.
curves <- data.frame(
  epoch = seq_along(training$metrics$loss),
  loss = training$metrics$loss, val_loss = training$metrics$val_loss
)
write.csv(curves, "outputs/neural-loss.csv", row.names = FALSE)

## ---- neural-plot ----
# Save the loss plot for use in the workshop webpage.
png("figures/05-neural-loss.png", width = 1200, height = 900, res = 150)
matplot(curves$epoch, curves[, c("loss", "val_loss")],
  type = "l", lty = 1,
  col = c("steelblue", "firebrick"),
  xlab = "Epoch",
  ylab = "Binary cross-entropy"
)
legend("topright",
  c("Training", "Validation"),
  col = c("steelblue", "firebrick"),
  lty = 1
)
dev.off()

# Record package versions so the run can be checked later.
capture.output(sessionInfo(), file = "outputs/session-info-neural.txt")

# Article section 2.2.3, using the current keras3 interface.
source("R/01-data.R")
library(mlr3)
library(keras3)
set_random_seed(20261023)
heart_task <- as_task_classif(heart, target = "heart_disease", positive = "present", id = "heart")
set.seed(20261023)
split <- partition(heart_task, ratio = 2/3)
# Binary predictors use 0/1; remaining nominal predictors use all indicators.
# This explicit reconstruction yields the article's 22 input columns.
x_data <- heart[, setdiff(names(heart), "heart_disease")]
for (nm in c("sex", "fasting_blood_sugar", "exercise_induced_angina")) {
  x_data[[nm]] <- as.integer(x_data[[nm]]) - 1L
}
nominal <- names(x_data)[vapply(x_data, is.factor, logical(1))]
contrasts_full <- lapply(x_data[nominal], function(x) contrasts(x, contrasts = FALSE))
x <- model.matrix(~ . - 1, data = x_data, contrasts.arg = contrasts_full)
stopifnot(ncol(x) == 22L, all(is.finite(x)))
# Added for numerical stability: fit numeric scaling on inner training rows only.
# Keras takes the final 20% of supplied training rows for validation.
inner_n <- floor(length(split$train) * 0.8)
fit_rows <- split$train[seq_len(inner_n)]
continuous <- names(x_data)[vapply(x_data, is.numeric, logical(1))]
continuous <- setdiff(continuous, c("sex", "fasting_blood_sugar", "exercise_induced_angina"))
centre <- colMeans(x[fit_rows, continuous, drop = FALSE])
spread <- apply(x[fit_rows, continuous, drop = FALSE], 2, sd)
stopifnot(all(spread > 0))
x[, continuous] <- sweep(sweep(x[, continuous, drop = FALSE], 2, centre), 2, spread, "/")
y <- as.integer(heart$heart_disease == "present")
network <- keras_model_sequential(input_shape = c(22)) |>
  layer_dense(units = 64, activation = "relu") |>
  layer_dropout(rate = 0.4) |>
  layer_dense(units = 32, activation = "relu") |>
  layer_dropout(rate = 0.4) |>
  layer_dense(units = 1, activation = "sigmoid")
compile(network, optimizer = optimizer_adam(learning_rate = 0.002),
        loss = "binary_crossentropy", metrics = "accuracy")
training <- fit(network, x[split$train, ], y[split$train], epochs = 50,
  batch_size = 32, validation_split = 0.2, verbose = 0,
  callbacks = list(callback_early_stopping(patience = 10, restore_best_weights = TRUE)))
prob <- as.numeric(predict(network, x[split$test, ], verbose = 0))
class <- ifelse(prob >= 0.5, "present", "absent")
accuracy <- mean(class == as.character(heart$heart_disease[split$test]))
print(accuracy)
write.csv(data.frame(row_id = split$test, truth = heart$heart_disease[split$test],
  probability_present = prob, prediction = class), "outputs/neural-predictions.csv", row.names = FALSE)
write.csv(data.frame(accuracy = accuracy), "outputs/neural-accuracy.csv", row.names = FALSE)
curves <- data.frame(epoch = seq_along(training$metrics$loss),
  loss = training$metrics$loss, val_loss = training$metrics$val_loss)
write.csv(curves, "outputs/neural-loss.csv", row.names = FALSE)
png("figures/05-neural-loss.png", width = 1200, height = 900, res = 150)
matplot(curves$epoch, curves[, c("loss", "val_loss")], type = "l", lty = 1,
        col = c("steelblue", "firebrick"), xlab = "Epoch", ylab = "Binary cross-entropy")
legend("topright", c("Training", "Validation"), col = c("steelblue", "firebrick"), lty = 1)
dev.off()
capture.output(sessionInfo(), file = "outputs/session-info-neural.txt")

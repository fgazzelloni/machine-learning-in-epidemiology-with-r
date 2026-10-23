# Run from part2/ to check the core packages and patient data.
# This checks the R setup, not whether the Keras Python backend is ready.
required <- c(
  "mlr3",
  "mlr3learners",
  "mlr3viz",
  "rpart",
  "rpart.plot",
  "ranger",
  "ggplot2",
  "precrec"
)

# Report missing packages before trying the lesson.
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop("Missing core packages: ", paste(missing, collapse = ", "))

# Confirm the raw file is available, then run the preparation checks.
stopifnot(file.exists("data/raw/heart-statlog.arff"))
source("R/01-data.R")
message("Core article workflow is ready: 270 patients, 13 predictors; 150 absent, 120 present.")
message("Neural-network, tuning and synthetic-data dependencies are checked when those scripts run.")

# Optional extension: search for useful model settings within training data.
# These full searches can take a long time. Settings follow article section 4.
# Run from the part2 folder, or pass the script path from another directory.
# Example: Rscript part2/R/04-tuning.R random_search

file_arg <- grep("^--file=.+", commandArgs(trailingOnly = FALSE), value = TRUE)
source_files <- vapply(sys.frames(), function(frame) {
  if (is.null(frame$ofile)) NA_character_ else as.character(frame$ofile)
}, character(1))
source_files <- source_files[!is.na(source_files)]

script_file <- if (length(file_arg) > 0) {
  sub("^--file=", "", file_arg[1])
} else if (length(source_files) > 0) {
  tail(source_files, 1)
} else {
  candidates <- c(
    file.path(getwd(), "R", "04-tuning.R"),
    file.path(getwd(), "04-tuning.R")
  )
  candidates <- candidates[file.exists(candidates)]
  if (length(candidates) == 0) {
    stop("Cannot locate 04-tuning.R; run it from part2/ or source the script.")
  }
  candidates[1]
}

script_dir <- dirname(normalizePath(script_file, mustWork = TRUE))
project_dir <- dirname(script_dir)
setwd(project_dir)

# Load the data and the tools used to fit and tune boosted trees.
source(file.path(script_dir, "01-data.R"))
library(mlr3)
library(mlr3learners)
library(mlr3tuning)
library(mlr3mbo)
set.seed(20261023)

# Define the outcome, then keep one-third of patients aside for testing.
heart_task <- as_task_classif(heart,
  target = "heart_disease",
  positive = "present",
  id = "heart"
)
split <- partition(heart_task, ratio = 2 / 3)

# XGBoost needs numbers: convert categories into numerical columns.
# The categories are fixed by the data guide; this step estimates no values
# from the patients held out during cross-validation.
encoded <- model.matrix(~ . - 1, 
                        heart[, setdiff(names(heart),
                                        "heart_disease")])

boost_task <- as_task_classif(
  data.frame(encoded, heart_disease = heart$heart_disease),
  target = "heart_disease", 
  positive = "present", id = "heart_xgboost"
)

# Search within the training patients only; do not use test outcomes to tune.
train_task <- boost_task$clone()$filter(split$train)

# to_tune() gives the range of candidate values for each setting.
# These control the number and depth of trees, learning speed and regularisation
# (a penalty that limits model complexity).
boost <- lrn("classif.xgboost",
  nthread = 1,
  nrounds = to_tune(1, 500), max_depth = to_tune(1, 20),
  eta = to_tune(1e-10, 1), lambda = to_tune(1e-10, 1)
)

# Read the search method supplied after the script name in the terminal.
mode <- commandArgs(trailingOnly = TRUE)
choices <- c("grid_search", "random_search", "mbo", "nested")
if (length(mode) == 0 && interactive()) {
  mode <- utils::select.list(
    choices,
    title = "Choose a tuning method",
    multiple = FALSE
  )
}
if (length(mode) == 0 || !nzchar(mode[1])) {
  stop("Choose grid_search, random_search, mbo or nested; see README.md.")
}

mode <- match.arg(mode[1], choices)

measure <- msr("classif.acc")

# Nested cross-validation separates setting selection from evaluation.
# Inner folds choose settings; outer folds evaluate the whole tuning process.
if (mode == "nested") {
  tuned <- auto_tuner(
    tuner = tnr("mbo"), learner = boost,
    resampling = rsmp("cv", folds = 10), measure = measure,
    terminator = trm("evals", n_evals = 100)
  )
  result <- resample(boost_task, 
                     tuned, 
                     rsmp("cv", folds = 10), 
                     store_models = TRUE)

  # Save the score from each outer test fold.
  write.csv(
    result$score(measure)[, c("iteration", "classif.acc"), 
                          with = FALSE],
    "outputs/tuning-nested.csv",
    row.names = FALSE
  )
  result$aggregate(measure)
} else {
  # Grid search tries a fixed set of combinations; random search samples them.
  # MBO (model-based optimisation) uses earlier results to choose the next trial.
  tuner <- switch(mode,
    grid_search = tnr("grid_search",
      resolution = 10,
      batch_size = 20
    ),
    random_search = tnr("random_search"),
    mbo = tnr("mbo")
  )

  # Set how many combinations each search may try.
  budget <- switch(mode,
    grid_search = trm("none"),
    random_search = trm("evals", n_evals = 500),
    mbo = trm("evals", n_evals = 30)
  )

  # Compare settings using cross-validation within the training group.
  instance <- tune(
    tuner = tuner, 
    task = train_task, 
    learner = boost,
    resampling = rsmp("cv", folds = 10), 
    measures = measure, 
    terminator = budget
  )

  # Refit the chosen settings on all training patients, then score the test group.
  final <- lrn("classif.xgboost", nthread = 1)
  
  final$param_set$values <- instance$result_learner_param_vals
  final$train(boost_task, row_ids = split$train)
  score <- final$predict(boost_task, row_ids = split$test)$score(measure)
  score

  # Save the held-out accuracy and chosen settings for later inspection.
  write.csv(data.frame(accuracy = unname(score)),
    paste0(
      "outputs/tuning-",
      mode,
      ".csv"
    ),
    row.names = FALSE
  )
  saveRDS(
    instance$result_learner_param_vals,
    paste0(
      "outputs/tuning-",
      mode,
      "-parameters.rds"
    )
  )
}

# Record the package versions used for this search.
capture.output(sessionInfo(), 
               file = paste0("outputs/session-info-", 
                             mode, ".txt"))
